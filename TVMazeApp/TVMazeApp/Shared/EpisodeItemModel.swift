//
//  EpisodeItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct EpisodeItemModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let airDate: Date?
    let runtime: Int?
    let rating: String?
    let imageURL: URL?
    let largeImageURL: URL?
    let summary: String?
}
