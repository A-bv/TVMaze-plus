//
//  ShowDetailItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct ShowDetailItemModel: Equatable {
    let runtime: Int?
    let episodeCount: Int
    let seasons: [SeasonItemModel]
    let cast: [CreditItemModel]
    let crew: [CreditItemModel]
    let gallery: [GalleryItemModel]
    let akas: [AkaItemModel]
}

struct SeasonItemModel: Identifiable, Equatable {
    let number: Int
    let episodes: [EpisodeItemModel]

    var id: Int { number }
}

struct GalleryItemModel: Identifiable, Equatable {
    let id: Int
    let url: URL
}

struct AkaItemModel: Identifiable, Equatable {
    let name: String
    let country: String?

    var id: String { name + (country ?? "") }
}
