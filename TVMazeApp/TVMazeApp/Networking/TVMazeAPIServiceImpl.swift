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
    }

    private let session: DataSession

    init(session: DataSession = URLSession.shared) {
        self.session = session
    }

    func fetchShowsFromAPI(show: String) async throws -> [ShowSearchModel] {
        try await fetch(
            path: Constant.showSearchPath,
            queryItems: [URLQueryItem(name: Constant.searchQueryName, value: show)])
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
