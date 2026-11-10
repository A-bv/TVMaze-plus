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
        static let tonightTitle = String(localized: "On TV tonight")
        static let tonightPick = String(localized: "Tonight's pick")
        static let countryCodeKey = "countryCode"
        static let countryCodes = [
            "AU", "BE", "BR", "CA", "CN", "DE", "DK", "FR", "GB", "JP", "KR", "MX", "NL", "RU", "TR", "US"
        ]
    }

    enum TonightState: Equatable {
        case loading
        case loaded(TonightItemModel)
        case failed
    }

    struct ScheduleRequest: Equatable {
        let day: Date
        let countryCode: String
    }

    private let service: TVMazeAPIService
    private let defaults: UserDefaults
    private let transformer = TonightTransformer()

    let days: [Date]
    let regions: [RegionItemModel]
    var selectedDay: Date
    var countryCode: String {
        didSet {
            defaults.set(countryCode, forKey: Constants.countryCodeKey)
        }
    }
    private(set) var state: TonightState = .loading
    private var loadedRequest: ScheduleRequest?

    init(
        service: TVMazeAPIService = TVMazeAPIServiceImpl(),
        defaults: UserDefaults = .standard,
        deviceCountryCode: String? = Locale.current.region?.identifier,
        now: Date = .now
    ) {
        self.service = service
        self.defaults = defaults
        let savedCountryCode = defaults.string(forKey: Constants.countryCodeKey)
        let coveredCountryCode = [savedCountryCode, deviceCountryCode]
            .compactMap { $0 }
            .first { Constants.countryCodes.contains($0) }
        countryCode = coveredCountryCode ?? Constants.fallbackCountryCode
        regions = Constants.countryCodes
            .map { RegionItemModel(code: $0) }
            .sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        let today = Calendar.current.startOfDay(for: now)
        days = (0..<Constants.dayCount).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: today)
        }
        selectedDay = today
    }

    var isTonight: Bool {
        selectedDay == days.first
    }

    var timelineTitle: String {
        isTonight ? Constants.tonightTitle : String(localized: "On TV \(weekday) evening")
    }

    var pickTitle: String {
        isTonight ? Constants.tonightPick : String(localized: "Pick for \(weekday)")
    }

    var request: ScheduleRequest {
        ScheduleRequest(day: selectedDay, countryCode: countryCode)
    }

    var region: RegionItemModel {
        RegionItemModel(code: countryCode)
    }

    private var weekday: String {
        selectedDay.formatted(.dateTime.weekday(.wide))
    }

    func loadSchedule() async {
        let request = request
        guard loadedRequest != request else { return }
        loadedRequest = nil
        state = .loading
        do {
            let schedule = try await service.fetchSchedule(date: request.day, countryCode: request.countryCode)
            let webSchedule = try await service.fetchWebSchedule(date: request.day)
            if Task.isCancelled { return }
            state = .loaded(transformer.transform(
                schedule: schedule,
                webSchedule: webSchedule,
                countryCode: request.countryCode))
            loadedRequest = request
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }
}
