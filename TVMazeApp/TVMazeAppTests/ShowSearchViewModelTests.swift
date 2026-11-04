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

    @Test(arguments: [
        TVMazeAPIServiceError.decodingError,
        TVMazeAPIServiceError.invalidResponse,
        TVMazeAPIServiceError.invalidURL,
        URLError(.notConnectedToInternet),
    ] as [any Error])
    func viewModel_whenSearchFails_isFailed(error: any Error) async {
        let sut = makeSut(service: MockTVMazeAPIService(mockedShows: [], error: error))

        await sut.loadShows(entry: "girls")

        #expect(sut.state == .failed)
    }

    @Test func viewModel_whenCancelledSearchFails_staysLoading() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: URLError(.cancelled))
        let sut = makeSut(service: service)
        let search = Task { await sut.loadShows(entry: "") }
        search.cancel()
        await search.value
        #expect(sut.state == .loading)
    }

    @Test func viewModel_whenSearchIsCancelled_doesNotShowResults() async {
        let service = MockTVMazeAPIService(mockedShows: FakeShowSearchData.makeShows())
        let sut = makeSut(service: service)
        let search = Task { await sut.loadShows(entry: "") }
        search.cancel()
        await search.value
        #expect(sut.state == .loading)
    }
}

extension ShowSearchViewModelTests {
    private func makeSut(service: TVMazeAPIService) -> ShowSearchViewModel {
        ShowSearchViewModel(service: service)
    }
}

private final class MockTVMazeAPIService: TVMazeAPIService {
    private let mockedShows: [ShowSearchModel]
    private let error: Error?
    
    init(
        mockedShows: [ShowSearchModel],
        error: Error? = nil
    ) {
        self.mockedShows = mockedShows
        self.error = error
    }
    
    func fetchShowsFromAPI(show: String) async throws -> [ShowSearchModel] {
        guard let error else {
            return mockedShows
        }
        
        throw error
    }
}
