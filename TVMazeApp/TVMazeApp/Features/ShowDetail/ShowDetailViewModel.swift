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

    var selectedEpisodes: [EpisodeItemModel] {
        guard case .loaded(let detail) = state else { return [] }
        return detail.seasons.first { $0.number == selectedSeason }?.episodes ?? []
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
