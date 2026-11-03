//
//  DataSession.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 04.10.2026.
//

import Foundation

protocol DataSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: DataSession {}
