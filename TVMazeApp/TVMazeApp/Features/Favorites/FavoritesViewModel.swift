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
    private enum Constants {
        static let weekDayCount = 6
    }

    enum SortOrder: String, CaseIterable, Identifiable {
        case dateAdded
        case nextEpisode
        case name
        case rating

        var id: Self { self }

        var title: String {
            switch self {
            case .dateAdded: String(localized: "Date added")
            case .nextEpisode: String(localized: "Next episode")
            case .name: String(localized: "Name")
            case .rating: String(localized: "Rating")
            }
        }
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

    func refresh(_ favorites: [SavedShowModel]) {
        for show in refreshedShows {
            guard let favorite = favorites.first(where: { $0.id == show.id }), favorite.showItem != show else { continue }
            favorite.update(from: show)
        }
    }

    func nextAirDate(of showID: Int) -> Date? {
        upNextByShow[showID]?.airDate
    }

    func status(of favorite: SavedShowModel, includesTime: Bool = false, now: Date = .now) -> String {
        guard let airDate = nextAirDate(of: favorite.id) else { return favorite.status }
        let lastWeekDay = Calendar.current.date(byAdding: .day, value: Constants.weekDayCount, to: now) ?? now
        let day: Date.FormatStyle = airDate < lastWeekDay
            ? .dateTime.weekday(.abbreviated)
            : .dateTime.day().month(.abbreviated)
        return airDate.formatted(includesTime ? day.hour().minute() : day)
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
