//
//  ShowDetailViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class ShowDetailViewModel {
    private enum Constants {
        static let separator = " · "
    }

    enum DetailState: Equatable {
        case loading
        case loaded(ShowDetailItemModel)
        case failed
    }

    private let service: TVMazeAPIService
    private let transformer = ShowDetailTransformer()

    private(set) var state: DetailState = .loading
    var selectedSeason: Int?

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    var detail: ShowDetailItemModel? {
        guard case .loaded(let detail) = state else { return nil }
        return detail
    }

    var selectedEpisodes: [EpisodeItemModel] {
        detail?.seasons.first { $0.number == selectedSeason }?.episodes ?? []
    }

    var allEpisodes: [EpisodeItemModel] {
        detail?.seasons.flatMap(\.episodes) ?? []
    }

    func subtitle(of show: ShowItemModel) -> String {
        [show.years, show.status, show.channel]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }

    func loadDetail(showID: Int) async {
        if case .loaded = state { return }
        state = .loading
        do {
            let model = try await service.fetchShow(id: showID)
            if Task.isCancelled { return }
            let detail = transformer.transform(model)
            selectedSeason = detail.seasons.last { !$0.episodes.isEmpty }?.number ?? detail.seasons.first?.number
            state = .loaded(detail)
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }
}
