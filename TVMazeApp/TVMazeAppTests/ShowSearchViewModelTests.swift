//
//  ShowSearchViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 30.09.2026.
//

import Testing
@testable import TVMazeApp
import Foundation

@MainActor
struct ShowSearchViewModelTests {
    @Test func viewModel_whenSearchSucceeds_isLoadedWithShowsAndEntry() async {
        let fakeData = FakeShowSearchData.makeShows()
        let expected = ShowSearchTransformer().transform(fakeData)
        let sut = makeSut(service: MockTVMazeAPIService(mockedShows: fakeData))

        await sut.loadShows(entry: "girls")

        #expect(sut.state == .loaded(shows: expected, entry: "girls"))
    }

    @Test func viewModel_whenSearchFindsNothing_isLoadedWithNoShows() async {
        let sut = makeSut(service: MockTVMazeAPIService(mockedShows: []))

        await sut.loadShows(entry: "unknown show")

        #expect(sut.state == .loaded(shows: [], entry: "unknown show"))
    }

    @Test func viewModel_whenSearchFails_isFailed() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.invalidResponse)
        let sut = makeSut(service: service)

        await sut.loadShows(entry: "girls")

        #expect(sut.state == .failed)
    }

    @Test func viewModel_whenEntryIsEmpty_doesNotSearch() async {
        let service = MockTVMazeAPIService(mockedShows: [])
        let sut = makeSut(service: service)

        await sut.loadShows(entry: "")

        #expect(service.fetchCallCount == 0)
        #expect(sut.state == .idle)
    }

    @Test func viewModel_whenEntryIsAlreadyLoaded_doesNotSearchAgain() async {
        let service = MockTVMazeAPIService(mockedShows: [])
        let sut = makeSut(service: service)

        await sut.loadShows(entry: "girls")
        await sut.loadShows(entry: "girls")

        #expect(service.fetchCallCount == 1)
    }

    @Test func viewModel_whenEntryChanges_searchesAgain() async {
        let service = MockTVMazeAPIService(mockedShows: [])
        let sut = makeSut(service: service)

        await sut.loadShows(entry: "girls")
        await sut.loadShows(entry: "lost")

        #expect(service.fetchCallCount == 2)
        #expect(sut.state == .loaded(shows: [], entry: "lost"))
    }

    @Test func viewModel_whenLastSearchFailed_searchesAgain() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.invalidResponse)
        let sut = makeSut(service: service)

        await sut.loadShows(entry: "girls")
        await sut.loadShows(entry: "girls")

        #expect(service.fetchCallCount == 2)
    }

    @Test func viewModel_whenCancelledSearchFails_staysLoading() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: URLError(.cancelled))
        let sut = makeSut(service: service)

        await cancelledSearch(sut, entry: "girls")

        #expect(sut.state == .loading)
    }

    @Test func viewModel_whenCancelledSearchSucceeds_staysLoading() async {
        let service = MockTVMazeAPIService(mockedShows: FakeShowSearchData.makeShows())
        let sut = makeSut(service: service)

        await cancelledSearch(sut, entry: "girls")

        #expect(sut.state == .loading)
    }
}

extension ShowSearchViewModelTests {
    private func makeSut(service: TVMazeAPIService) -> ShowSearchViewModel {
        ShowSearchViewModel(service: service)
    }

    private func cancelledSearch(_ sut: ShowSearchViewModel, entry: String) async {
        let search = Task { await sut.loadShows(entry: entry) }
        search.cancel()
        await search.value
    }
}
