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
}
