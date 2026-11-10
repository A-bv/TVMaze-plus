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
        #expect(try await sut.fetchShows(name: "girls") == [])
    }
    
    @Test func service_whenDataIsInvalidAndStatusCodeIs200_throwsDecodingError() async {
        let invalidJson = "{[]}"
        let invalidData = Data(invalidJson.utf8)
        let mockedSession = MockedURLSession(fakeData: invalidData, statusCode: 200)
        let sut = makeSut(session: mockedSession)
        let expectedError = TVMazeAPIServiceError.decodingError
        await #expect(throws: expectedError) {
            try await sut.fetchShows(name: "girls")
        }
    }
    
    @Test func service_whenStatusCodeIs404_throwsInvalidResponseError() async {
        let mockedSession = MockedURLSession(fakeData: Data(), statusCode: 404)
        let sut = makeSut(session: mockedSession)
        let expectedError = TVMazeAPIServiceError.invalidResponse
        await #expect(throws: expectedError) {
            try await sut.fetchShows(name: "girls")
        }
    }
    
    @Test func service_whenRealGirlsResponse_decodesAllShows() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "girls_search_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)
        
        let shows = try await sut.fetchShows(name: "girls")
        
        #expect(shows.count == 2)

        let showTheMostFilled = try #require(shows.first)
        #expect(showTheMostFilled.show.network?.name == "HBO")
        #expect(showTheMostFilled.show.averageRuntime == 30)
        
        let showTheMostFilledWithNil = try #require(shows.last)
        #expect(showTheMostFilledWithNil.show.premiered == nil)
        #expect(showTheMostFilledWithNil.show.image == nil)
        #expect(showTheMostFilledWithNil.show.language == nil)
    }

    @Test func service_whenSearchHasSpecialCharacters_encodesThemInTheURL() async throws {
        let mockedSession = MockedURLSession(fakeData: Data("[]".utf8), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        _ = try await sut.fetchShows(name: "law & order c#?")

        let expectedURL = "https://api.tvmaze.com/search/shows?q=law%20%26%20order%20c%23?"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
    }

    @Test func service_whenRealShowResponse_decodesTheShowWithItsDetails() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "show_detail_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let detail = try await sut.fetchShow(id: 44933)

        let expectedURL = "https://api.tvmaze.com/shows/44933?embed%5B%5D=seasons&embed%5B%5D=episodes"
            + "&embed%5B%5D=cast&embed%5B%5D=crew&embed%5B%5D=images&embed%5B%5D=akas"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
        #expect(detail.show.name == "Severance")
        #expect(detail.embedded.seasons.count == 3)
        #expect(detail.embedded.episodes.count == 19)
        #expect(detail.embedded.cast.count == 11)
        #expect(detail.embedded.crew.count == 71)
        #expect(detail.embedded.images.count == 15)
        #expect(detail.embedded.akas.count == 7)
    }

    @Test func service_whenRealEpisodeResponse_decodesTheEpisodeWithItsGuests() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "episode_detail_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let detail = try await sut.fetchEpisode(id: 2939707)

        let expectedURL = "https://api.tvmaze.com/episodes/2939707?embed%5B%5D=guestcast&embed%5B%5D=guestcrew"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
        #expect(detail.episode.name == "Chikhai Bardo")
        #expect(detail.episode.season == 2)
        #expect(detail.episode.number == 7)
        #expect(detail.embedded.guestcast.count == 5)
        #expect(detail.embedded.guestcrew.count == 3)
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
