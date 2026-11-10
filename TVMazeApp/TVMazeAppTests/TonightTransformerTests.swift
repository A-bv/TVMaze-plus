//
//  TonightTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct TonightTransformerTests {
    @Test func transformer_keepsTheEveningEntriesGroupedByTime() throws {
        let tonight = try makeTonight()

        #expect(tonight.timeSlots.count == 2)
        #expect(tonight.timeSlots.map { $0.entries.map(\.show.name) } == [
            ["FBI", "St. Denis Medical"],
            ["The Fall and Rise of Reggie Dinkins"]
        ])
    }

    @Test func transformer_keepsOnlyTheChannelsOfTheScheduleCountry() throws {
        let tonight = TonightTransformer().transform(
            schedule: try Fixtures.decode([ScheduleEpisodeModel].self, named: "schedule_response"),
            webSchedule: [],
            countryCode: "GB")

        #expect(tonight.timeSlots.isEmpty)
    }

    @Test func transformer_keepsOneEpisodePerStreamingShow_mostPopularFirst() throws {
        let tonight = try makeTonight()

        #expect(tonight.streaming.map(\.show.name) == ["Murdoch Mysteries", "Love Is Blind", "I Was Actually There"])
        #expect(tonight.streaming.last?.episode.number == 1)
    }

    @Test func transformer_picksTheMostPopularShow_preferringTV() throws {
        let tonight = try makeTonight()

        #expect(tonight.pick?.show.name == "FBI")
        #expect(tonight.pick?.episode.name == "Ultimatum")
    }

    @Test func transformer_namesTheCountryAndItsTimeZone() throws {
        let tonight = try makeTonight()

        #expect(tonight.country == Locale.current.localizedString(forRegionCode: "US"))
        #expect(tonight.timeZone.identifier == "America/New_York")
    }

    @Test func transformer_withEmptySchedules_hasNoPick() {
        let tonight = TonightTransformer().transform(schedule: [], webSchedule: [], countryCode: "US")

        #expect(tonight.pick == nil)
        #expect(tonight.streaming.isEmpty)
        #expect(tonight.timeSlots.isEmpty)
        #expect(tonight.timeZone == .current)
    }
}

extension TonightTransformerTests {
    private func makeTonight() throws -> TonightItemModel {
        TonightTransformer().transform(
            schedule: try Fixtures.decode([ScheduleEpisodeModel].self, named: "schedule_response"),
            webSchedule: try Fixtures.decode([ScheduleEpisodeModel].self, named: "web_schedule_response"),
            countryCode: "US")
    }
}
