//
//  TVMazeAPIServiceImpl.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 04.10.2026.
//

import Foundation

final class TVMazeAPIServiceImpl: TVMazeAPIService {
    private enum Constant {
        static let successCode = 200
        static let searchEndpoint = "https://api.tvmaze.com/search/shows"
        static let searchQueryName = "q"
    }

    private let session: DataSession

    init(session: DataSession = URLSession.shared) {
        self.session = session
    }

    func fetchShowsFromAPI(show: String) async throws -> [ShowSearchModel] {
        let url = try makeSearchURL(for: show)
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == Constant.successCode else {
            throw TVMazeAPIServiceError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([ShowSearchModel].self, from: data)
        } catch {
            throw TVMazeAPIServiceError.decodingError
        }
    }

    private func makeSearchURL(for show: String) throws -> URL {
        guard let endpoint = URL(string: Constant.searchEndpoint) else {
            throw TVMazeAPIServiceError.invalidURL
        }
        return endpoint.appending(queryItems: [URLQueryItem(name: Constant.searchQueryName, value: show)])
    }
}
