//
//  MockTVMazeAPIService.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
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
    var schedules: [String: [ScheduleEpisodeModel]] = [:]
    var webSchedule: [ScheduleEpisodeModel] = []
    var upNext: [Int: ShowUpNextModel] = [:]
    private(set) var fetchCallCount = 0
    private(set) var requestedCountryCodes: [String] = []

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

    func fetchSchedule(date: Date, countryCode: String) async throws -> [ScheduleEpisodeModel] {
        requestedCountryCodes.append(countryCode)
        return try respond(with: schedules[countryCode, default: []])
    }

    func fetchWebSchedule(date: Date) async throws -> [ScheduleEpisodeModel] {
        try respond(with: webSchedule)
    }

    func fetchUpNext(showID: Int) async throws -> ShowUpNextModel {
        try respond(with: upNext[showID])
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
