//
//  TVMazeAPIService.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 28.09.2026.
//

import Foundation

protocol TVMazeAPIService {
    func fetchShows(name: String) async throws -> [ShowSearchModel]
}
