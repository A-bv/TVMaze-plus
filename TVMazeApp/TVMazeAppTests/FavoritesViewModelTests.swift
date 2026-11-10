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
}
