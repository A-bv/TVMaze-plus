//
//  EpisodeTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct EpisodeTransformerTests {
    @Test func transformer_withRealEpisode_transformsToExpectedData() throws {
        let sut = makeSut()
        let episode = try Fixtures.decode(EpisodeDetailModel.self, named: "episode_detail_response").episode

        let transformedEpisode = sut.transform(episode)

        #expect(transformedEpisode.name == "Chikhai Bardo")
        #expect(transformedEpisode.season == 2)
        #expect(transformedEpisode.number == 7)
        #expect(transformedEpisode.airDate == Date(timeIntervalSince1970: 1740744000))
        #expect(transformedEpisode.runtime == 50)
        #expect(transformedEpisode.rating == "7.7")
        #expect(transformedEpisode.summary == "An old romance intersects with a deadly present threat.")
        #expect(transformedEpisode.imageURL?.absoluteString.contains("medium_landscape") == true)
    }

    @Test func transformer_withMissingValues_leavesThemEmpty() {
        let sut = makeSut()
        let episode = Episode(
            id: 1,
            name: "Special",
            season: 1,
            number: nil,
            airdate: nil,
            airstamp: nil,
            runtime: nil,
            rating: Rating(average: nil),
            image: nil,
            summary: "<p></p>")

        let transformedEpisode = sut.transform(episode)

        #expect(transformedEpisode.number == nil)
        #expect(transformedEpisode.airDate == nil)
        #expect(transformedEpisode.rating == nil)
        #expect(transformedEpisode.imageURL == nil)
        #expect(transformedEpisode.summary == nil)
    }
}

extension EpisodeTransformerTests {
    private func makeSut() -> EpisodeTransformer {
        EpisodeTransformer()
    }
}
