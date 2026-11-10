//
//  TVMazeAPIServiceImpl.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 30.09.2026.
//

import Foundation

final class TVMazeAPIServiceImpl: TVMazeAPIService {
    private enum Constant {
        static let successCode = 200
        static let baseURL = "https://api.tvmaze.com"
        static let showSearchPath = "/search/shows"
        static let peopleSearchPath = "/search/people"
        static let searchQueryName = "q"
        static let showPath = "/shows/"
        static let showEmbeds = ["seasons", "episodes", "cast", "crew", "images", "akas"]
        static let episodePath = "/episodes/"
        static let episodeEmbeds = ["guestcast", "guestcrew"]
        static let embedQueryName = "embed[]"
        static let singleEmbedQueryName = "embed"
        static let personPath = "/people/"
        static let castCreditsPath = "/castcredits"
        static let crewCreditsPath = "/crewcredits"
        static let guestCreditsPath = "/guestcastcredits"
        static let showEmbed = "show"
        static let episodeEmbed = "episode"
        static let upNextEmbeds = ["nextepisode", "images"]
        static let schedulePath = "/schedule"
        static let webSchedulePath = "/schedule/web"
        static let dateQueryName = "date"
        static let countryQueryName = "country"
    }

    private let session: DataSession

    init(session: DataSession = URLSession.shared) {
        self.session = session
    }

    func fetchShows(name: String) async throws -> [ShowSearchModel] {
        try await fetch(
            path: Constant.showSearchPath,
            queryItems: [URLQueryItem(name: Constant.searchQueryName, value: name)])
    }

    func fetchShow(id: Int) async throws -> ShowDetailModel {
        try await fetch(path: Constant.showPath + String(id), queryItems: embedQueryItems(Constant.showEmbeds))
    }

    func fetchEpisode(id: Int) async throws -> EpisodeDetailModel {
        try await fetch(path: Constant.episodePath + String(id), queryItems: embedQueryItems(Constant.episodeEmbeds))
    }

    func fetchPeople(name: String) async throws -> [PersonSearchModel] {
        try await fetch(
            path: Constant.peopleSearchPath,
            queryItems: [URLQueryItem(name: Constant.searchQueryName, value: name)])
    }

    func fetchCastCredits(personID: Int) async throws -> [PersonCastCreditModel] {
        try await fetchPersonCredits(personID: personID, path: Constant.castCreditsPath, embed: Constant.showEmbed)
    }

    func fetchCrewCredits(personID: Int) async throws -> [PersonCrewCreditModel] {
        try await fetchPersonCredits(personID: personID, path: Constant.crewCreditsPath, embed: Constant.showEmbed)
    }

    func fetchGuestCredits(personID: Int) async throws -> [PersonGuestCreditModel] {
        try await fetchPersonCredits(personID: personID, path: Constant.guestCreditsPath, embed: Constant.episodeEmbed)
    }

    func fetchSchedule(date: Date, countryCode: String) async throws -> [ScheduleEpisodeModel] {
        try await fetch(
            path: Constant.schedulePath,
            queryItems: [
                URLQueryItem(name: Constant.dateQueryName, value: formatDay(date)),
                URLQueryItem(name: Constant.countryQueryName, value: countryCode)
            ])
    }

    func fetchWebSchedule(date: Date) async throws -> [ScheduleEpisodeModel] {
        try await fetch(
            path: Constant.webSchedulePath,
            queryItems: [URLQueryItem(name: Constant.dateQueryName, value: formatDay(date))])
    }

    func fetchUpNext(showID: Int) async throws -> ShowUpNextModel {
        try await fetch(path: Constant.showPath + String(showID), queryItems: embedQueryItems(Constant.upNextEmbeds))
    }

    private func formatDay(_ date: Date) -> String {
        date.formatted(Date.ISO8601FormatStyle(timeZone: .current).year().month().day())
    }

    private func fetchPersonCredits<Model: Decodable>(personID: Int, path: String, embed: String) async throws -> Model {
        try await fetch(
            path: Constant.personPath + String(personID) + path,
            queryItems: [URLQueryItem(name: Constant.singleEmbedQueryName, value: embed)])
    }

    private func embedQueryItems(_ embeds: [String]) -> [URLQueryItem] {
        embeds.map { URLQueryItem(name: Constant.embedQueryName, value: $0) }
    }

    private func fetch<Model: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> Model {
        guard let endpoint = URL(string: Constant.baseURL + path) else {
            throw TVMazeAPIServiceError.invalidURL
        }

        let url = endpoint.appending(queryItems: queryItems)
        let (data, response) = try await data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == Constant.successCode else {
            throw TVMazeAPIServiceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            throw TVMazeAPIServiceError.decodingError
        }
    }

    private func data(from url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: URLRequest(url: url))
        } catch let error as URLError where error.code != .cancelled {
            return try await session.data(for: URLRequest(url: url, cachePolicy: .returnCacheDataDontLoad))
        }
    }
}
