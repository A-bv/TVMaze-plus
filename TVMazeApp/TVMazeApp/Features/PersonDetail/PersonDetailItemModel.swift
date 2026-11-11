//
//  PersonDetailItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct PersonDetailItemModel: Equatable {
    let knownFor: [ShowCreditItemModel]
    let behindTheCamera: [ShowCreditItemModel]
    let guestAppearances: [GuestAppearanceItemModel]
    let showCount: Int
}

struct ShowCreditItemModel: Identifiable, Equatable {
    let show: ShowItemModel
    let role: String

    var id: Int { show.id }
}

struct GuestAppearanceItemModel: Identifiable, Equatable {
    let episode: EpisodeItemModel
    let showName: String
    let character: String

    var id: Int { episode.id }

    var details: String {
        [showName, episode.code, episode.airDate?.formatted(date: .abbreviated, time: .omitted)]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}
