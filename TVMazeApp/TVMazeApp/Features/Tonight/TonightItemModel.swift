//
//  TonightItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct TonightItemModel: Equatable {
    let pick: ScheduleItemModel?
    let isPickOnTV: Bool
    let streaming: [ScheduleItemModel]
    let timeSlots: [TimeSlotItemModel]
    let timeZone: TimeZone
    let timeZoneName: String
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

struct RegionItemModel: Identifiable, Equatable {
    private enum Constants {
        static let flagScalarOffset: UInt32 = 127397
    }

    let code: String

    var id: String { code }

    var name: String {
        Locale.current.localizedString(forRegionCode: code) ?? code
    }

    var flag: String {
        String(String.UnicodeScalarView(code.unicodeScalars.compactMap {
            UnicodeScalar(Constants.flagScalarOffset + $0.value)
        }))
    }
}
