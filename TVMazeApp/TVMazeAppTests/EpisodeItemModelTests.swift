//
//  EpisodeItemModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct EpisodeItemModelTests {
    @Test func episode_withNumber_putsItBeforeItsName() {
        #expect(makeEpisode(number: 4).numberedName == "4 · Woe's Hollow")
    }

    @Test func episode_withoutNumber_showsOnlyItsName() {
        #expect(makeEpisode(number: nil).numberedName == "Woe's Hollow")
    }

    @Test func episode_withAirDateAndRuntime_detailsBoth() {
        let airDate = Date(timeIntervalSince1970: 1_738_886_400)

        let details = makeEpisode(airDate: airDate, runtime: 50).details

        #expect(details == "\(airDate.formatted(date: .abbreviated, time: .omitted)) · \(50.runtimeText)")
    }

    @Test func episode_withoutAirDateOrRuntime_hasNoDetails() {
        #expect(makeEpisode().details.isEmpty)
    }
}

extension EpisodeItemModelTests {
    private func makeEpisode(number: Int? = 4, airDate: Date? = nil, runtime: Int? = nil) -> EpisodeItemModel {
        EpisodeItemModel(
            id: 1,
            name: "Woe's Hollow",
            season: 2,
            number: number,
            airDate: airDate,
            runtime: runtime,
            rating: nil,
            imageURL: nil,
            largeImageURL: nil,
            summary: nil)
    }
}
