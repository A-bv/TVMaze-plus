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

    @Test func service_whenRealPeopleResponse_decodesAllPeople() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "people_search_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let people = try await sut.fetchPeople(name: "adam scott")

        #expect(mockedSession.requestedURL?.absoluteString == "https://api.tvmaze.com/search/people?q=adam%20scott")
        #expect(people.count == 10)
        let personWithNilValues = try #require(people.first)
        #expect(personWithNilValues.person.country == nil)
        #expect(personWithNilValues.person.birthday == nil)
        let personTheMostFilled = try #require(people.dropFirst().first)
        #expect(personTheMostFilled.person.birthday == "1973-04-03")
        #expect(personTheMostFilled.person.country?.name == "United States")
    }

    @Test func service_whenRealCastCreditsResponse_decodesTheShowsAndCharacters() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "person_cast_credits_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let credits = try await sut.fetchCastCredits(personID: 31964)

        #expect(mockedSession.requestedURL?.absoluteString == "https://api.tvmaze.com/people/31964/castcredits?embed=show")
        #expect(credits.count == 8)
        #expect(credits.first?.embedded.show.name == "Parks and Recreation")
        #expect(credits.first?.links.character.name == "Ben Wyatt")
    }

    @Test func service_whenRealCrewCreditsResponse_decodesTheShowsAndJobs() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "person_crew_credits_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let credits = try await sut.fetchCrewCredits(personID: 31964)

        #expect(mockedSession.requestedURL?.absoluteString == "https://api.tvmaze.com/people/31964/crewcredits?embed=show")
        #expect(credits.count == 7)
        #expect(credits.first?.embedded.show.name == "Ghosted")
        #expect(credits.first?.type == "Executive Producer")
    }

    @Test func service_whenRealGuestCreditsResponse_decodesTheEpisodesAndTheirShows() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "person_guest_credits_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let credits = try await sut.fetchGuestCredits(personID: 31964)

        let expectedURL = "https://api.tvmaze.com/people/31964/guestcastcredits?embed=episode"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
        #expect(credits.count == 4)
        let credit = try #require(credits.first)
        #expect(credit.embedded.episode.episode.name == "The Master Plan")
        #expect(credit.embedded.episode.links.show.name == "Parks and Recreation")
        #expect(credit.links.character.name == "Ben Wyatt")
    }

    @Test func service_whenRealScheduleResponse_decodesTheEpisodesWithTheirShows() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "schedule_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let schedule = try await sut.fetchSchedule(date: try makeDay(), countryCode: "US")

        #expect(mockedSession.requestedURL?.absoluteString == "https://api.tvmaze.com/schedule?date=2026-11-09&country=US")
        #expect(schedule.count == 4)
        #expect(schedule.first?.episode.name == "I think we should be buds")
        #expect(schedule.first?.airtime == "00:00")
        #expect(schedule.first?.show.name == "The Terrors of Jordan Mendoza")
        #expect(schedule.first?.show.weight == 95)
    }

    @Test func service_whenRealWebScheduleResponse_decodesTheEpisodesWithTheirEmbeddedShows() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "web_schedule_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let schedule = try await sut.fetchWebSchedule(date: try makeDay())

        #expect(mockedSession.requestedURL?.absoluteString == "https://api.tvmaze.com/schedule/web?date=2026-11-09")
        #expect(schedule.count == 5)
        #expect(schedule.first?.show.name == "I Was Actually There")
        #expect(schedule.last?.airtime == "")
        #expect(schedule.first?.show.webChannel?.name == "ABC iview")
    }

    @Test func service_whenRealUpNextResponse_decodesTheNextEpisodeAndImages() async throws {
        let mockedSession = MockedURLSession(fakeData: try Fixtures.data(named: "show_up_next_response"), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let upNext = try await sut.fetchUpNext(showID: 55350)

        let expectedURL = "https://api.tvmaze.com/shows/55350?embed%5B%5D=nextepisode&embed%5B%5D=images"
        #expect(mockedSession.requestedURL?.absoluteString == expectedURL)
        #expect(upNext.show.name == "Abbott Elementary")
        #expect(upNext.embedded.nextepisode?.name == "Competition")
        #expect(upNext.embedded.images.count == 18)
    }

    @Test func service_whenShowHasNoNextEpisode_decodesItAsMissing() async throws {
        let data = try Fixtures.data(named: "show_up_next_response")
        var json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        json["_embedded"] = ["images": []]
        let mockedSession = MockedURLSession(fakeData: try JSONSerialization.data(withJSONObject: json), statusCode: 200)
        let sut = makeSut(session: mockedSession)

        let upNext = try await sut.fetchUpNext(showID: 55350)

        #expect(upNext.embedded.nextepisode == nil)
    }
}

extension TVMazeAPIServiceTests {
    private func makeSut(session: DataSession) -> TVMazeAPIService {
        TVMazeAPIServiceImpl(session: session)
    }

    private func makeDay() throws -> Date {
        try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 9, hour: 12)))
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
