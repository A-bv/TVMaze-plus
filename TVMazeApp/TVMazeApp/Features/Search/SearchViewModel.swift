//
//  SearchViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 30.09.2026.
//

import Observation
import Foundation

@Observable
final class SearchViewModel {

    enum SearchScope: CaseIterable {
        case shows
        case people
    }

    enum SearchState: Equatable {
        case idle
        case loading
        case loaded(shows: [ShowItemModel], entry: String)
        case loadedPeople(people: [PersonItemModel], entry: String)
        case failed
    }

    private let service: TVMazeAPIService
    private let transformer = ShowTransformer()
    private let personTransformer = PersonTransformer()

    private(set) var state: SearchState = .idle

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    func search(entry: String, scope: SearchScope) async {
        switch scope {
        case .shows:
            await loadShows(entry: entry)
        case .people:
            await loadPeople(entry: entry)
        }
    }

    func loadShows(entry: String) async {
        guard !entry.isEmpty else { return }
        if case .loaded(_, entry) = state { return }
        state = .loading
        do {
            let results = try await service.fetchShows(name: entry)
            if Task.isCancelled { return }
            state = .loaded(shows: results.map { transformer.transform($0.show) }, entry: entry)
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }

    func loadPeople(entry: String) async {
        guard !entry.isEmpty else { return }
        if case .loadedPeople(_, entry) = state { return }
        state = .loading
        do {
            let results = try await service.fetchPeople(name: entry)
            if Task.isCancelled { return }
            state = .loadedPeople(people: results.map { personTransformer.transform($0.person) }, entry: entry)
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }
}
