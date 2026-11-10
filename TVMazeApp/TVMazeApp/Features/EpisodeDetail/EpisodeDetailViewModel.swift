//
//  EpisodeDetailViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class EpisodeDetailViewModel {

    enum GuestsState: Equatable {
        case loading
        case loaded(EpisodeGuestsItemModel)
        case failed
    }

    private let service: TVMazeAPIService
    private let transformer = EpisodeDetailTransformer()
    private let episodes: [EpisodeItemModel]

    private(set) var episode: EpisodeItemModel
    private(set) var state: GuestsState = .loading

    init(
        episode: EpisodeItemModel,
        episodes: [EpisodeItemModel],
        service: TVMazeAPIService = TVMazeAPIServiceImpl()
    ) {
        self.episode = episode
        self.episodes = episodes
        self.service = service
    }

    var previousEpisode: EpisodeItemModel? {
        neighbor(offset: -1)
    }

    var nextEpisode: EpisodeItemModel? {
        neighbor(offset: 1)
    }

    func select(_ episode: EpisodeItemModel) {
        self.episode = episode
        state = .loading
    }

    func loadGuests() async {
        do {
            let model = try await service.fetchEpisode(id: episode.id)
            if Task.isCancelled { return }
            state = .loaded(transformer.transform(model))
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }

    private func neighbor(offset: Int) -> EpisodeItemModel? {
        guard let index = episodes.firstIndex(where: { $0.id == episode.id }),
              episodes.indices.contains(index + offset) else {
            return nil
        }
        return episodes[index + offset]
    }
}
