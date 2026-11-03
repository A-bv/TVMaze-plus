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
    @Test func viewModel_callsLoadShows_succeedsAndPopulatesShows() async {
        let fakeData = FakeShowSearchData.makeShows()
        let service = MockTVMazeAPIService(mockedShows: fakeData)
        let expected = ShowSearchTransformer().transform(fakeData)
        
        let sut = makeSut(service: service)
        await sut.loadShows(entry: "")
        
        #expect(sut.shows == expected)
        #expect(sut.isShowingAlert == false)
        #expect(sut.isLoading == false)
        #expect(sut.unexpectedError == nil)
    }
    
    @Test func viewModel_callsLoadShows_failsAndSetsApiErrorWithDecodingError() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.decodingError)
        let sut = makeSut(service: service)
        let expected = TVMazeAPIServiceError.decodingError
        await sut.loadShows(entry: "")
        #expect(sut.apiError == expected)
        #expect(sut.isShowingAlert == true)
        #expect(sut.isLoading == false)
        #expect(sut.unexpectedError == nil)
        #expect(sut.shows.isEmpty)
    }
    
    @Test func viewModel_callsLoadShows_failsAndSetsApiErrorWithInvalidResponse() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.invalidResponse)
        let sut = makeSut(service: service)
        let expected = TVMazeAPIServiceError.invalidResponse
        await sut.loadShows(entry: "")
        #expect(sut.apiError == expected)
        #expect(sut.isShowingAlert == true)
        #expect(sut.isLoading == false)
        #expect(sut.unexpectedError == nil)
        #expect(sut.shows.isEmpty)
    }
    
    @Test func viewModel_callsLoadShows_failsAndSetsApiErrorWithInvalidURL() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.invalidURL)
        let sut = makeSut(service: service)
        let expected = TVMazeAPIServiceError.invalidURL
        await sut.loadShows(entry: "")
        #expect(sut.apiError == expected)
        #expect(sut.isShowingAlert == true)
        #expect(sut.isLoading == false)
        #expect(sut.unexpectedError == nil)
        #expect(sut.shows.isEmpty)
    }
    
    @Test func viewModel_callsLoadShows_failsAndSetsUnexpectedErrorWithAnyError() async {
        let expected = URLError(.notConnectedToInternet)
        let service = MockTVMazeAPIService(mockedShows: [], error: expected)
        let sut = makeSut(service: service)
        await sut.loadShows(entry: "")
        #expect(sut.apiError == nil)
        #expect(sut.isShowingAlert == true)
        #expect(sut.isLoading == false)
        #expect(sut.unexpectedError as? URLError == expected)
        #expect(sut.shows.isEmpty)
    }

    @Test func viewModel_whenCancelledSearchFails_showsNoAlert() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: URLError(.cancelled))
        let sut = makeSut(service: service)
        let search = Task { await sut.loadShows(entry: "") }
        search.cancel()
        await search.value
        #expect(sut.isShowingAlert == false)
        #expect(sut.apiError == nil)
        #expect(sut.unexpectedError == nil)
    }

    @Test func viewModel_whenSearchIsCancelled_doesNotReplaceShows() async {
        let service = MockTVMazeAPIService(mockedShows: FakeShowSearchData.makeShows())
        let sut = makeSut(service: service)
        let search = Task { await sut.loadShows(entry: "") }
        search.cancel()
        await search.value
        #expect(sut.shows.isEmpty)
        #expect(sut.isShowingAlert == false)
    }

    @Test func viewModel_whenSearchSucceeds_remembersTheSearchedEntry() async {
        let service = MockTVMazeAPIService(mockedShows: [])
        let sut = makeSut(service: service)
        await sut.loadShows(entry: "unknown show")
        #expect(sut.searchedEntry == "unknown show")
        #expect(sut.shows.isEmpty)
    }

    @Test func viewModel_whenSearchFails_forgetsTheSearchedEntry() async {
        let service = MockTVMazeAPIService(mockedShows: [], error: TVMazeAPIServiceError.invalidResponse)
        let sut = makeSut(service: service)
        await sut.loadShows(entry: "girls")
        #expect(sut.searchedEntry == nil)
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
