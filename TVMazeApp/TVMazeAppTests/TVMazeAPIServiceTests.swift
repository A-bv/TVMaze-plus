//
//  TVMazeAPIServiceTests.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 03.10.2026.
//

import Testing
@testable import TVMazeApp
import Foundation

@MainActor
struct TVMazeAPIServiceTests {
    @Test func service_whenValidDataAndStatusCodeIs200_returnsDecodedDataEmptyList() async throws {
        let validData = Data("[]".utf8)
        let mockedSession = MockedURLSession(fakeData: validData, statusCode: 200)
        let sut = makeSut(session: mockedSession)
        #expect(try await sut.fetchShowsFromAPI(show: "girls") == [])
    }
    
    @Test func service_whenDataIsInvalidAndStatusCodeIs200_throwsDecodingError() async {
        let invalidJson = "{[]}"
        let invalidData = Data(invalidJson.utf8)
        let mockedSession = MockedURLSession(fakeData: invalidData, statusCode: 200)
        let sut = makeSut(session: mockedSession)
        let expectedError = TVMazeAPIServiceError.decodingError
        await #expect(throws: expectedError) {
            try await sut.fetchShowsFromAPI(show: "girls")
        }
    }
    
    @Test func service_whenStatusCodeIs404_throwsInvalidResponseError() async {
        let mockedSession = MockedURLSession(fakeData: Data(), statusCode: 404)
        let sut = makeSut(session: mockedSession)
        let expectedError = TVMazeAPIServiceError.invalidResponse
        await #expect(throws: expectedError) {
            try await sut.fetchShowsFromAPI(show: "girls")
        }
    }
    
    @Test func service_whenRealGirlsResponse_decodesAllShows() async throws {
        let bundle = Bundle(for: MockedURLSession.self)
        
        let jsonLocation = bundle.url(forResource: "girls_search_response", withExtension: "json")
        let jsonLocalURL = try #require(jsonLocation)
        
        let fakeFetchedData = try Data(contentsOf: jsonLocalURL)
        let fakeSuccessCode = 200
        
        let mockedSession = MockedURLSession(fakeData: fakeFetchedData, statusCode: fakeSuccessCode)
        let sut = makeSut(session: mockedSession)
        
        let shows = try await sut.fetchShowsFromAPI(show: "girls")
        
        #expect(shows.count == 2)
        
        let showTheMostFilledWithNil = try #require(shows.last)
        #expect(showTheMostFilledWithNil.show.premiered == nil)
        #expect(showTheMostFilledWithNil.show.image == nil)
        #expect(showTheMostFilledWithNil.show.language == nil)
    }

    @Test func service_whenSearchHasSpecialCharacters_encodesThemInTheURL() async throws {
        let mockedSession = MockedURLSession(fakeData: Data("[]".utf8), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        _ = try await sut.fetchShowsFromAPI(show: "law & order c#?")

        let expectedURL = "https://api.tvmaze.com/search/shows?q=law%20%26%20order%20c%23?"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
    }
}

extension TVMazeAPIServiceTests {
    private func makeSut(session: DataSession) -> TVMazeAPIService {
        TVMazeAPIServiceImpl(session: session)
    }
}

private final class MockedURLSession: DataSession {
    private let fakeData: Data
    private let statusCode: Int
    private(set) var requestedURL: URL?

    init(fakeData: Data, statusCode: Int) {
        self.fakeData = fakeData
        self.statusCode = statusCode
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        requestedURL = url
        guard let fakeResponse: URLResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)
        else {
            throw URLError(.unknown)
        }
        return (fakeData, fakeResponse)
    }
}
