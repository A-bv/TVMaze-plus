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
    private let transformer: ShowSearchTransformer

    private(set) var state: SearchState = .idle

    init(service: TVMazeAPIService,
         transformer: ShowSearchTransformer = ShowSearchTransformer()) {
        self.service = service
        self.transformer = transformer
    }

    func loadShows(entry: String) async {
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
