//
//  ShowDetailViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct ShowDetailViewModelTests {
    @Test func viewModel_whenDetailLoads_selectsTheLastSeasonWithEpisodes() async throws {
        let service = MockTVMazeAPIService()
        service.showDetail = try makeDetail()
        let sut = makeSut(service: service)

        await sut.loadDetail(showID: 44933)

        #expect(sut.state == .loaded(ShowDetailTransformer().transform(try makeDetail())))
        #expect(sut.selectedSeason == 2)
        #expect(sut.selectedEpisodes.count == 10)
    }

    @Test func viewModel_whenSeasonHasNoEpisodes_selectsNoEpisodes() async throws {
        let service = MockTVMazeAPIService()
        service.showDetail = try makeDetail()
        let sut = makeSut(service: service)

        await sut.loadDetail(showID: 44933)
        sut.selectedSeason = 3

        #expect(sut.selectedEpisodes.isEmpty)
    }

    @Test func viewModel_whenDetailLoads_offersTheEpisodesOfEverySeason() async throws {
        let service = MockTVMazeAPIService()
        service.showDetail = try makeDetail()
        let sut = makeSut(service: service)

        await sut.loadDetail(showID: 44933)

        #expect(sut.allEpisodes.count == 19)
    }

    @Test func viewModel_beforeDetailLoads_hasNoDetailOrEpisodes() {
        let sut = makeSut(service: MockTVMazeAPIService())

        #expect(sut.detail == nil)
        #expect(sut.allEpisodes.isEmpty)
    }

    @Test func viewModel_subtitlesTheShowWithTheFieldsItHas() {
        let sut = makeSut(service: MockTVMazeAPIService())

        #expect(sut.subtitle(of: makeShow(channel: "Apple TV")) == "2022 – 2025 · Ended · Apple TV")
        #expect(sut.subtitle(of: makeShow(channel: nil)) == "2022 – 2025 · Ended")
    }

    @Test func viewModel_whenDetailFails_isFailed() async {
        let sut = makeSut(service: MockTVMazeAPIService(error: TVMazeAPIServiceError.invalidResponse))

        await sut.loadDetail(showID: 44933)

        #expect(sut.state == .failed)
    }

    @Test func viewModel_whenDetailIsAlreadyLoaded_doesNotLoadAgain() async throws {
        let service = MockTVMazeAPIService()
        service.showDetail = try makeDetail()
        let sut = makeSut(service: service)

        await sut.loadDetail(showID: 44933)
        await sut.loadDetail(showID: 44933)

        #expect(service.fetchCallCount == 1)
    }
}

extension ShowDetailViewModelTests {
    private func makeSut(service: TVMazeAPIService) -> ShowDetailViewModel {
        ShowDetailViewModel(service: service)
    }

    private func makeDetail() throws -> ShowDetailModel {
        try Fixtures.decode(ShowDetailModel.self, named: "show_detail_response")
    }

    private func makeShow(channel: String?) -> ShowItemModel {
        ShowItemModel(
            id: 44933,
            name: "Severance",
            posterURL: nil,
            years: "2022 – 2025",
            status: "Ended",
            channel: channel,
            genres: "",
            rating: nil,
            largePosterURL: nil,
            summary: "",
            type: "Scripted",
            language: "English",
            websiteURL: nil,
            lastUpdated: .now)
    }
}
