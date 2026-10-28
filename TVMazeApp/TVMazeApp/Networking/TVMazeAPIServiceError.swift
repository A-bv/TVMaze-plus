//
//  TVMazeAPIServiceError.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 01.10.2026.
//

enum TVMazeAPIServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
