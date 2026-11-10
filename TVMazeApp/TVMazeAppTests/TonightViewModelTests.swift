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
        let sut = makeSut(now: now)

        #expect(sut.days.count == 7)
        #expect(sut.days.first == Calendar.current.startOfDay(for: now))
        #expect(sut.selectedDay == sut.days.first)
        #expect(sut.isTonight)
    }

    @Test func viewModel_whenScheduleLoads_isLoaded() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = makeSut(service: service)

        await sut.loadSchedule()

        #expect(sut.state == .loaded(try makeTonight()))
        #expect(service.requestedCountryCodes == ["US"])
    }

    @Test func viewModel_startsWithTheDeviceRegion() {
        let sut = makeSut(deviceCountryCode: "GB")

        #expect(sut.countryCode == "GB")
        #expect(sut.region.flag == "🇬🇧")
    }

    @Test func viewModel_whenTheDeviceRegionHasNoListings_startsWithTheUS() {
        let sut = makeSut(deviceCountryCode: "CH")

        #expect(sut.countryCode == "US")
    }

    @Test func viewModel_whenARegionWasPicked_startsWithIt() {
        let defaults = makeDefaults()
        makeSut(defaults: defaults).countryCode = "JP"

        let sut = makeSut(defaults: defaults)

        #expect(sut.countryCode == "JP")
    }

    @Test func viewModel_offersTheDeviceRegionAmongItsRegions() {
        let sut = makeSut()

        #expect(sut.regions.contains(sut.region))
        #expect(sut.regions.map(\.name) == sut.regions.map(\.name).sorted { $0.localizedCompare($1) == .orderedAscending })
    }

    @Test func viewModel_whenAnotherRegionIsPicked_loadsItsSchedule() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = makeSut(service: service)

        await sut.loadSchedule()
        sut.countryCode = "GB"
        await sut.loadSchedule()

        #expect(service.requestedCountryCodes == ["US", "GB"])
    }

    @Test func viewModel_whenDayIsAlreadyLoaded_doesNotLoadAgain() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = makeSut(service: service)

        await sut.loadSchedule()
        await sut.loadSchedule()

        #expect(service.requestedCountryCodes == ["US"])
    }

    @Test func viewModel_whenAnotherDayIsSelected_loadsAgain() async throws {
        let service = try makeService(scheduleCountryCode: "US")
        let sut = makeSut(service: service)

        await sut.loadSchedule()
        sut.selectedDay = sut.days[1]
        await sut.loadSchedule()

        #expect(service.requestedCountryCodes == ["US", "US"])
    }

    @Test func viewModel_whenAnotherDayIsSelected_isNotTonight() {
        let sut = makeSut()

        sut.selectedDay = sut.days[1]

        #expect(!sut.isTonight)
    }

    @Test func viewModel_tonight_titlesItsListingsAndPickForTonight() {
        let sut = makeSut()

        #expect(sut.timelineTitle == String(localized: "On TV tonight"))
        #expect(sut.pickTitle == String(localized: "Tonight's pick"))
    }

    @Test func viewModel_whenAnotherDayIsSelected_titlesItsListingsAndPickWithItsWeekday() {
        let sut = makeSut()

        sut.selectedDay = sut.days[1]

        let weekday = sut.days[1].formatted(.dateTime.weekday(.wide))
        #expect(sut.timelineTitle == String(localized: "On TV \(weekday) evening"))
        #expect(sut.pickTitle == String(localized: "Pick for \(weekday)"))
    }

    @Test func viewModel_whenScheduleFails_isFailed() async {
        let sut = makeSut(service: MockTVMazeAPIService(error: TVMazeAPIServiceError.invalidResponse))

        await sut.loadSchedule()

        #expect(sut.state == .failed)
    }
}

extension TonightViewModelTests {
    @discardableResult
    private func makeSut(
        service: TVMazeAPIService = MockTVMazeAPIService(),
        defaults: UserDefaults? = nil,
        deviceCountryCode: String = "US",
        now: Date = .now
    ) -> TonightViewModel {
        TonightViewModel(
            service: service,
            defaults: defaults ?? makeDefaults(),
            deviceCountryCode: deviceCountryCode,
            now: now)
    }

    private func makeDefaults() -> UserDefaults {
        UserDefaults(suiteName: UUID().uuidString) ?? .standard
    }

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
