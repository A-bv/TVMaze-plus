//
//  TonightViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct TonightViewModelTests {
    @Test func viewModel_offersAWeekStartingToday() {
        let now = Date(timeIntervalSince1970: 1_794_300_000)
        let sut = TonightViewModel(service: MockTVMazeAPIService(), countryCode: "US", now: now)

        #expect(sut.days.count == 7)
        #expect(sut.days.first == Calendar.current.startOfDay(for: now))
        #expect(sut.selectedDay == sut.days.first)
        #expect(sut.isTonight)
    }

    @Test func viewModel_whenScheduleLoads_isLoaded() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = TonightViewModel(service: service, countryCode: "US")

        await sut.loadSchedule()

        #expect(sut.state == .loaded(try makeTonight()))
        #expect(service.requestedCountryCodes == ["US"])
    }

    @Test func viewModel_whenLocalScheduleIsEmpty_fallsBackToTheUS() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = TonightViewModel(service: service, countryCode: "CH")

        await sut.loadSchedule()

        #expect(sut.state == .loaded(try makeTonight()))
        #expect(service.requestedCountryCodes == ["CH", "US"])
    }

    @Test func viewModel_whenAnotherDayIsSelected_isNotTonight() {
        let sut = TonightViewModel(service: MockTVMazeAPIService(), countryCode: "US")

        sut.selectedDay = sut.days[1]

        #expect(!sut.isTonight)
    }

    @Test func viewModel_whenScheduleFails_isFailed() async {
        let sut = TonightViewModel(
            service: MockTVMazeAPIService(error: TVMazeAPIServiceError.invalidResponse),
            countryCode: "US")

        await sut.loadSchedule()

        #expect(sut.state == .failed)
    }
}

extension TonightViewModelTests {
    private func makeService(scheduleCountryCode: String) throws -> MockTVMazeAPIService {
        let service = MockTVMazeAPIService()
        service.schedules[scheduleCountryCode] = try Fixtures.decode([ScheduleEpisodeModel].self, named: "schedule_response")
        service.webSchedule = try Fixtures.decode([ScheduleEpisodeModel].self, named: "web_schedule_response")
        return service
    }

    private func makeTonight() throws -> TonightItemModel {
        TonightTransformer().transform(
            schedule: try Fixtures.decode([ScheduleEpisodeModel].self, named: "schedule_response"),
            webSchedule: try Fixtures.decode([ScheduleEpisodeModel].self, named: "web_schedule_response"),
            countryCode: "US")
    }
}
