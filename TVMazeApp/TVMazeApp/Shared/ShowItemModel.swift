//
//  ShowItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

import Foundation

struct ShowItemModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let posterURL: URL?
    let years: String
    let status: String
    let genres: String
    let rating: String
    let largePosterURL: URL?
    let summary: String
    let type: String
    let language: String
    let websiteURL: URL?
    let lastUpdated: Date
}
