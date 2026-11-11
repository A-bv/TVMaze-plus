//
//  PersonDetailViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class PersonDetailViewModel {
    private enum Constants {
        static let separator = " · "
    }

    enum DetailState: Equatable {
        case loading
        case loaded(PersonDetailItemModel)
        case failed
    }

    private let service: TVMazeAPIService
    private let transformer = PersonDetailTransformer()

    private(set) var state: DetailState = .loading

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    var detail: PersonDetailItemModel? {
        guard case .loaded(let detail) = state else { return nil }
        return detail
    }

    func loadDetail(personID: Int) async {
        if case .loaded = state { return }
        state = .loading
        do {
            let castCredits = try await service.fetchCastCredits(personID: personID)
            let crewCredits = try await service.fetchCrewCredits(personID: personID)
            let guestCredits = try await service.fetchGuestCredits(personID: personID)
            if Task.isCancelled { return }
            state = .loaded(transformer.transform(
                castCredits: castCredits,
                crewCredits: crewCredits,
                guestCredits: guestCredits))
        } catch {
            if Task.isCancelled { return }
            state = .failed
        }
    }

    func age(of person: PersonItemModel, now: Date = .now) -> Int? {
        guard let birthday = person.birthday else { return nil }
        return Calendar.current.dateComponents([.year], from: birthday, to: person.deathday ?? now).year
    }

    func subtitle(of person: PersonItemModel) -> String {
        [
            person.birthday.map { String(localized: "Born \($0.formatted(date: .long, time: .omitted))") },
            person.deathday.map { String(localized: "Died \($0.formatted(date: .long, time: .omitted))") },
            person.country
        ]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}
