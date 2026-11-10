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
        static let searchQueryName = "q"
        static let showPath = "/shows/"
        static let showEmbeds = ["seasons", "episodes", "cast", "crew", "images", "akas"]
        static let episodePath = "/episodes/"
        static let episodeEmbeds = ["guestcast", "guestcrew"]
        static let embedQueryName = "embed[]"
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

    private func embedQueryItems(_ embeds: [String]) -> [URLQueryItem] {
        embeds.map { URLQueryItem(name: Constant.embedQueryName, value: $0) }
    }

    private func fetch<Model: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> Model {
        guard let endpoint = URL(string: Constant.baseURL + path) else {
            throw TVMazeAPIServiceError.invalidURL
        }

        let url = endpoint.appending(queryItems: queryItems)
        let (data, response) = try await session.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == Constant.successCode else {
            throw TVMazeAPIServiceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            throw TVMazeAPIServiceError.decodingError
        }
    }
}
