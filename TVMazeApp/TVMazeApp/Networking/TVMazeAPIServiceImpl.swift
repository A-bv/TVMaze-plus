//
//  TVMazeAPIServiceImpl.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 04.10.2026.
//

import SwiftUI

final class TVMazeAPIServiceImpl: TVMazeAPIService {
    private enum Constant {
        static let successCode = 200
    }
    
    private let session: DataSession
    
    init(session: DataSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchShowsFromAPI(show: String) async throws -> [ShowSearchModel] {
        guard let url = URL(string: "https://api.tvmaze.com/search/shows?q=\(show)") else {
            throw TVMazeAPIServiceError.invalidURL
        }
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
}
