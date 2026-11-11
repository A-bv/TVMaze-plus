//
//  GuestAppearanceItemModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct GuestAppearanceItemModelTests {
    @Test func appearance_withAirDate_detailsShowCodeAndDate() {
        let airDate = Date(timeIntervalSince1970: 1_738_886_400)
        let appearance = makeAppearance(airDate: airDate)

        #expect(appearance.details == "Parks and Recreation · \(appearance.episode.code) · \(airDate.formatted(date: .abbreviated, time: .omitted))")
    }

    @Test func appearance_withoutAirDate_detailsShowAndCode() {
        let appearance = makeAppearance(airDate: nil)

        #expect(appearance.details == "Parks and Recreation · \(appearance.episode.code)")
    }
}

extension GuestAppearanceItemModelTests {
    private func makeAppearance(airDate: Date?) -> GuestAppearanceItemModel {
        GuestAppearanceItemModel(
            episode: EpisodeItemModel(
                id: 1,
                name: "Pilot",
                season: 1,
                number: 1,
                airDate: airDate,
                runtime: nil,
                rating: nil,
                imageURL: nil,
                largeImageURL: nil,
                summary: nil),
            showName: "Parks and Recreation",
            character: "Adam")
    }
}
