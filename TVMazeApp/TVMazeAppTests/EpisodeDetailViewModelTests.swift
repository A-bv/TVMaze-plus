//
//  EpisodeDetailViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct EpisodeDetailViewModelTests {
    @Test func viewModel_whenGuestsLoad_isLoadedWithCastAndCrew() async throws {
        let service = MockTVMazeAPIService()
        service.episodeDetail = try Fixtures.decode(EpisodeDetailModel.self, named: "episode_detail_response")
        let episodes = makeEpisodes()
        let sut = makeSut(episode: episodes[0], episodes: episodes, service: service)

        await sut.loadGuests()

        guard case .loaded(let guests) = sut.state else {
            Issue.record("Expected a loaded state")
            return
        }
        #expect(guests.cast.first?.person.name == "Ólafur Darri Ólafsson")
        #expect(guests.cast.first?.role == "Mr. Drummond")
        #expect(guests.crew.map(\.role) == ["Writer", "Writer", "Director"])
    }

    @Test func viewModel_whenGuestsFail_isFailed() async {
        let episodes = makeEpisodes()
        let service = MockTVMazeAPIService(error: TVMazeAPIServiceError.invalidResponse)
        let sut = makeSut(episode: episodes[0], episodes: episodes, service: service)

        await sut.loadGuests()

        #expect(sut.state == .failed)
    }

    @Test func viewModel_onFirstEpisode_hasOnlyANextEpisode() {
        let episodes = makeEpisodes()
        let sut = makeSut(episode: episodes[0], episodes: episodes, service: MockTVMazeAPIService())

        #expect(sut.previousEpisode == nil)
        #expect(sut.nextEpisode == episodes[1])
    }

    @Test func viewModel_whenNeighborIsSelected_showsItAndLoadsAgain() async throws {
        let service = MockTVMazeAPIService()
        service.episodeDetail = try Fixtures.decode(EpisodeDetailModel.self, named: "episode_detail_response")
        let episodes = makeEpisodes()
        let sut = makeSut(episode: episodes[1], episodes: episodes, service: service)
        await sut.loadGuests()

        sut.select(episodes[2])

        #expect(sut.episode == episodes[2])
        #expect(sut.state == .loading)
        #expect(sut.previousEpisode == episodes[1])
        #expect(sut.nextEpisode == nil)
    }
}

extension EpisodeDetailViewModelTests {
    private func makeSut(
        episode: EpisodeItemModel,
        episodes: [EpisodeItemModel],
        service: TVMazeAPIService
    ) -> EpisodeDetailViewModel {
        EpisodeDetailViewModel(episode: episode, episodes: episodes, service: service)
    }

    private func makeEpisodes() -> [EpisodeItemModel] {
        (1...3).map { number in
            EpisodeItemModel(
                id: number,
                name: "Episode \(number)",
                season: 1,
                number: number,
                airDate: nil,
                runtime: nil,
                rating: nil,
                imageURL: nil,
                largeImageURL: nil,
                summary: nil)
        }
    }
}
