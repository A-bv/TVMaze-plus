//
//  MockTVMazeAPIService.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

@testable import TVMazeApp

final class MockTVMazeAPIService: TVMazeAPIService {
    private let mockedShows: [ShowSearchModel]
    private let error: Error?
    var showDetail: ShowDetailModel?
    var episodeDetail: EpisodeDetailModel?
    var people: [PersonSearchModel] = []
    var castCredits: [PersonCastCreditModel] = []
    var crewCredits: [PersonCrewCreditModel] = []
    var guestCredits: [PersonGuestCreditModel] = []
    private(set) var fetchCallCount = 0

    init(
        mockedShows: [ShowSearchModel] = [],
        error: Error? = nil
    ) {
        self.mockedShows = mockedShows
        self.error = error
    }

    func fetchShows(name: String) async throws -> [ShowSearchModel] {
        try respond(with: mockedShows)
    }

    func fetchShow(id: Int) async throws -> ShowDetailModel {
        try respond(with: showDetail)
    }

    func fetchEpisode(id: Int) async throws -> EpisodeDetailModel {
        try respond(with: episodeDetail)
    }

    func fetchPeople(name: String) async throws -> [PersonSearchModel] {
        try respond(with: people)
    }

    func fetchCastCredits(personID: Int) async throws -> [PersonCastCreditModel] {
        try respond(with: castCredits)
    }

    func fetchCrewCredits(personID: Int) async throws -> [PersonCrewCreditModel] {
        try respond(with: crewCredits)
    }

    func fetchGuestCredits(personID: Int) async throws -> [PersonGuestCreditModel] {
        try respond(with: guestCredits)
    }

    private func respond<Model>(with model: Model?) throws -> Model {
        fetchCallCount += 1
        if let error {
            throw error
        }
        guard let model else {
            throw TVMazeAPIServiceError.invalidResponse
        }
        return model
    }
}
