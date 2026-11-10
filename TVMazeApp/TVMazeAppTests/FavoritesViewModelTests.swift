//
//  FavoritesViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct FavoritesViewModelTests {
    @Test func viewModel_listsOnlyTheShowsWithANextEpisode() async throws {
        let service = MockTVMazeAPIService()
        service.upNext = [
            55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response"),
            1: try UpNextFixtures.make(showID: 1, hasNextEpisode: false)
        ]
        let sut = FavoritesViewModel(service: service)

        await sut.loadUpNext(showIDs: [1, 55350])

        #expect(sut.upNext.map(\.show.name) == ["Abbott Elementary"])
    }

    @Test func viewModel_keepsTheLatestDataOfEveryFetchedShow() async throws {
        let service = MockTVMazeAPIService()
        service.upNext = [
            55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response"),
            1: try UpNextFixtures.make(showID: 1, hasNextEpisode: false)
        ]
        let sut = FavoritesViewModel(service: service)

        await sut.loadUpNext(showIDs: [1, 55350])

        #expect(sut.refreshedShows.map(\.id) == [1, 55350])
    }

    @Test func viewModel_whenFavoritesChange_fetchesOnlyTheNewShows() async throws {
        let service = MockTVMazeAPIService()
        service.upNext = [
            55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response"),
            1: try UpNextFixtures.make(showID: 1, hasNextEpisode: false)
        ]
        let sut = FavoritesViewModel(service: service)

        await sut.loadUpNext(showIDs: [55350])
        await sut.loadUpNext(showIDs: [55350, 1])

        #expect(service.fetchCallCount == 2)
    }

    @Test func viewModel_whenAShowIsRemoved_dropsItsNextEpisode() async throws {
        let service = MockTVMazeAPIService()
        service.upNext = [55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response")]
        let sut = FavoritesViewModel(service: service)

        await sut.loadUpNext(showIDs: [55350])
        await sut.loadUpNext(showIDs: [])

        #expect(sut.upNext.isEmpty)
    }

    @Test func viewModel_whenAFetchFails_triesAgainNextTime() async throws {
        let service = MockTVMazeAPIService()
        let sut = FavoritesViewModel(service: service)

        await sut.loadUpNext(showIDs: [55350])
        service.upNext = [55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response")]
        await sut.loadUpNext(showIDs: [55350])

        #expect(sut.upNext.map(\.show.name) == ["Abbott Elementary"])
    }

    @Test func viewModel_sortsByDateAdded_newestFirst() {
        let favorites = makeFavorites()

        let sorted = FavoritesViewModel(service: MockTVMazeAPIService()).sorted(favorites, by: .dateAdded)

        #expect(sorted.map(\.name) == ["Lost", "Abbott Elementary", "Severance"])
    }

    @Test func viewModel_sortsByName() {
        let sorted = FavoritesViewModel(service: MockTVMazeAPIService()).sorted(makeFavorites(), by: .name)

        #expect(sorted.map(\.name) == ["Abbott Elementary", "Lost", "Severance"])
    }

    @Test func viewModel_sortsByRating_unratedLast() {
        let sorted = FavoritesViewModel(service: MockTVMazeAPIService()).sorted(makeFavorites(), by: .rating)

        #expect(sorted.map(\.name) == ["Severance", "Abbott Elementary", "Lost"])
    }

    @Test func viewModel_sortsByNextEpisode_showsWithoutOneLast() async throws {
        let service = MockTVMazeAPIService()
        service.upNext = [55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response")]
        let sut = FavoritesViewModel(service: service)
        let favorites = makeFavorites()

        await sut.loadUpNext(showIDs: favorites.map(\.id))
        let sorted = sut.sorted(favorites, by: .nextEpisode)

        #expect(sorted.first?.name == "Abbott Elementary")
        #expect(sut.nextAirDate(of: 55350) != nil)
        #expect(sut.nextAirDate(of: 1) == nil)
    }

    @Test func viewModel_whenTheNextEpisodeIsThisWeek_showsItsWeekday() async throws {
        let sut = try await makeLoadedSut()
        let airDate = try #require(sut.nextAirDate(of: 55350))

        let status = sut.status(of: makeFavorite(id: 55350), now: airDate.addingTimeInterval(-86_400))

        #expect(status == airDate.formatted(.dateTime.weekday(.abbreviated)))
    }

    @Test func viewModel_whenTheNextEpisodeIsLater_showsItsDate() async throws {
        let sut = try await makeLoadedSut()
        let airDate = try #require(sut.nextAirDate(of: 55350))

        let status = sut.status(of: makeFavorite(id: 55350), now: airDate.addingTimeInterval(-10 * 86_400))

        #expect(status == airDate.formatted(.dateTime.day().month(.abbreviated)))
    }

    @Test func viewModel_whenAskedForTheTime_addsIt() async throws {
        let sut = try await makeLoadedSut()
        let airDate = try #require(sut.nextAirDate(of: 55350))

        let status = sut.status(of: makeFavorite(id: 55350), includesTime: true, now: airDate.addingTimeInterval(-86_400))

        #expect(status == airDate.formatted(.dateTime.weekday(.abbreviated).hour().minute()))
    }

    @Test func viewModel_whenAShowHasNoNextEpisode_showsItsStatus() {
        let sut = FavoritesViewModel(service: MockTVMazeAPIService())

        #expect(sut.status(of: makeFavorite(id: 1)) == "Running")
    }
}

extension FavoritesViewModelTests {
    private func makeLoadedSut() async throws -> FavoritesViewModel {
        let service = MockTVMazeAPIService()
        service.upNext = [55350: try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response")]
        let sut = FavoritesViewModel(service: service)
        await sut.loadUpNext(showIDs: [55350])
        return sut
    }

    private func makeFavorites() -> [SavedShowModel] {
        [
            makeFavorite(id: 1, name: "Severance", rating: "8.6", savedDaysAgo: 3),
            makeFavorite(id: 55350, name: "Abbott Elementary", rating: "7.9", savedDaysAgo: 2),
            makeFavorite(id: 2, name: "Lost", rating: nil, savedDaysAgo: 1)
        ]
    }

    private func makeFavorite(id: Int, name: String = "Abbott Elementary", rating: String? = nil, savedDaysAgo: Int = 0) -> SavedShowModel {
        let favorite = SavedShowModel(from: ShowItemModel(
            id: id,
            name: name,
            posterURL: nil,
            years: "2020",
            status: "Running",
            channel: nil,
            genres: "",
            rating: rating,
            largePosterURL: nil,
            summary: "",
            type: "Scripted",
            language: "English",
            websiteURL: nil,
            lastUpdated: .now))
        favorite.savedAt = Date.now.addingTimeInterval(TimeInterval(-savedDaysAgo * 86_400))
        return favorite
    }
}
