//
//  DataSession.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 04.10.2026.
//

import Foundation

protocol DataSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: DataSession {}
