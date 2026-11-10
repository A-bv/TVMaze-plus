//
//  TonightItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct TonightItemModel: Equatable {
    let pick: ScheduleItemModel?
    let streaming: [ScheduleItemModel]
    let timeSlots: [TimeSlotItemModel]
    let country: String
    let timeZone: TimeZone
}

struct ScheduleItemModel: Identifiable, Equatable {
    let show: ShowItemModel
    let episode: EpisodeItemModel

    var id: Int { episode.id }
}

struct TimeSlotItemModel: Identifiable, Equatable {
    let time: Date
    let entries: [ScheduleItemModel]

    var id: Date { time }
}
