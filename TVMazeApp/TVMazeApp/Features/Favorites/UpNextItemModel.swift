//
//  UpNextItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct UpNextItemModel: Identifiable, Equatable {
    let show: ShowItemModel
    let episode: EpisodeItemModel
    let airDate: Date
    let backgroundURL: URL?

    var id: Int { show.id }
}
