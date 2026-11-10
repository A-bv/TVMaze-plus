//
//  TonightViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class TonightViewModel {
    private enum Constants {
        static let dayCount = 7
        static let fallbackCountryCode = "US"
    }

    enum TonightState: Equatable {
        case loading
        case loaded(TonightItemModel)
        case failed
    }

    private let service: TVMazeAPIService
    private let countryCode: String
    private let transformer = TonightTransformer()

    let days: [Date]
    var selectedDay: Date
    private(set) var state: TonightState = .loading

    init(
        service: TVMazeAPIService = TVMazeAPIServiceImpl(),
        countryCode: String? = Locale.current.region?.identifier,
        now: Date = .now
    ) {
        self.service = service
        self.countryCode = countryCode ?? Constants.fallbackCountryCode
        let today = Calendar.current.startOfDay(for: now)
        days = (0..<Constants.dayCount).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: today)
        }
        selectedDay = today
    }

    var isTonight: Bool {
        selectedDay == days.first
    }

    func loadSchedule() async {
        state = .loading
        do {
            let (schedule, countryCode) = try await fetchTVSchedule()
            let webSchedule = try await service.fetchWebSchedule(date: selectedDay)
            if Task.isCancelled { return }
            state = .loaded(transformer.transform(
                schedule: schedule,
                webSchedule: webSchedule,
                countryCode: countryCode))
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }

    private func fetchTVSchedule() async throws -> (schedule: [ScheduleEpisodeModel], countryCode: String) {
        let schedule = try await service.fetchSchedule(date: selectedDay, countryCode: countryCode)
        guard schedule.isEmpty, countryCode != Constants.fallbackCountryCode else {
            return (schedule, countryCode)
        }
        let fallbackSchedule = try await service.fetchSchedule(
            date: selectedDay,
            countryCode: Constants.fallbackCountryCode)
        return (fallbackSchedule, Constants.fallbackCountryCode)
    }
}
