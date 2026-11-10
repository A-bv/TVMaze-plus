//
//  FavoritesViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class FavoritesViewModel {
    enum SortOrder: String, CaseIterable, Identifiable {
        case dateAdded
        case nextEpisode
        case name
        case rating

        var id: Self { self }
    }

    private let service: TVMazeAPIService
    private let transformer = UpNextTransformer()
    private let showTransformer = ShowTransformer()
    private var loadedShowIDs: Set<Int> = []
    private var upNextByShow: [Int: UpNextItemModel] = [:]

    private(set) var upNext: [UpNextItemModel] = []
    private(set) var refreshedShows: [ShowItemModel] = []

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    func loadUpNext(showIDs: [Int]) async {
        for showID in showIDs where !loadedShowIDs.contains(showID) {
            guard let model = try? await service.fetchUpNext(showID: showID) else { continue }
            if Task.isCancelled { return }
            loadedShowIDs.insert(showID)
            upNextByShow[showID] = transformer.transform(model)
            refreshedShows.append(showTransformer.transform(model.show))
        }
        upNext = showIDs
            .compactMap { upNextByShow[$0] }
            .sorted { $0.airDate < $1.airDate }
    }

    func nextAirDate(of showID: Int) -> Date? {
        upNextByShow[showID]?.airDate
    }

    func sorted(_ favorites: [SavedShowModel], by order: SortOrder) -> [SavedShowModel] {
        switch order {
        case .dateAdded:
            favorites.sorted { $0.savedAt > $1.savedAt }
        case .nextEpisode:
            favorites.sorted { nextAirDate(of: $0.id) ?? .distantFuture < nextAirDate(of: $1.id) ?? .distantFuture }
        case .name:
            favorites.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .rating:
            favorites.sorted { ratingValue(of: $0) > ratingValue(of: $1) }
        }
    }

    private func ratingValue(of favorite: SavedShowModel) -> Double {
        favorite.rating.flatMap(Double.init) ?? 0
    }
}
