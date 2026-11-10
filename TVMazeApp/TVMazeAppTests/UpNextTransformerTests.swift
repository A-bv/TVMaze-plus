//
//  UpNextTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct UpNextTransformerTests {
    @Test func transformer_withNextEpisode_keepsItsDateAndTheLatestBackground() throws {
        let upNext = try #require(UpNextTransformer().transform(try Fixtures.decode(ShowUpNextModel.self, named: "show_up_next_response")))

        #expect(upNext.show.name == "Abbott Elementary")
        #expect(upNext.episode.name == "Competition")
        #expect(upNext.airDate == Date(timeIntervalSince1970: 1_794_447_000))
        #expect(upNext.backgroundURL?.absoluteString == "https://static.tvmaze.com/uploads/images/original_untouched/644/1611889.jpg")
    }

    @Test func transformer_withoutNextEpisode_isEmpty() throws {
        let upNext = try UpNextFixtures.make(showID: 1, hasNextEpisode: false)

        #expect(UpNextTransformer().transform(upNext) == nil)
    }
}

@MainActor
enum UpNextFixtures {
    static func make(showID: Int, hasNextEpisode: Bool) throws -> ShowUpNextModel {
        let data = try Fixtures.data(named: "show_up_next_response")
        var json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        json["id"] = showID
        if !hasNextEpisode {
            json["_embedded"] = ["images": []]
        }
        return try JSONDecoder().decode(ShowUpNextModel.self, from: JSONSerialization.data(withJSONObject: json))
    }
}
