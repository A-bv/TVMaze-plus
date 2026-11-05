//
//  ShowSearchViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 30.09.2026.
//

import Observation
import Foundation

@Observable
final class ShowSearchViewModel {

    enum SearchState: Equatable {
        case idle
        case loading
        case loaded(shows: [ShowItemModel], entry: String)
        case failed
    }

    private let service: TVMazeAPIService
    private let transformer = ShowSearchTransformer()

    private(set) var state: SearchState = .idle

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    func loadShows(entry: String) async {
        guard !entry.isEmpty else { return }
        if case .loaded(_, entry) = state { return }
        state = .loading
        do {
            let results = try await service.fetchShowsFromAPI(show: entry)
            if Task.isCancelled { return }
            state = .loaded(shows: transformer.transform(results), entry: entry)
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }
}
