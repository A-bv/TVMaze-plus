//
//  TVMazeAPIService.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 28.09.2026.
//

import Foundation

protocol TVMazeAPIService {
    func fetchShows(name: String) async throws -> [ShowSearchModel]
    func fetchShow(id: Int) async throws -> ShowDetailModel
    func fetchEpisode(id: Int) async throws -> EpisodeDetailModel
    func fetchPeople(name: String) async throws -> [PersonSearchModel]
    func fetchCastCredits(personID: Int) async throws -> [PersonCastCreditModel]
    func fetchCrewCredits(personID: Int) async throws -> [PersonCrewCreditModel]
    func fetchGuestCredits(personID: Int) async throws -> [PersonGuestCreditModel]
    func fetchSchedule(date: Date, countryCode: String) async throws -> [ScheduleEpisodeModel]
    func fetchWebSchedule(date: Date) async throws -> [ScheduleEpisodeModel]
    func fetchUpNext(showID: Int) async throws -> ShowUpNextModel
}
