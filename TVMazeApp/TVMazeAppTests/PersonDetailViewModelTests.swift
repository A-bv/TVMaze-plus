//
//  PersonDetailViewModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct PersonDetailViewModelTests {
    @Test func viewModel_whenCreditsLoad_isLoaded() async throws {
        let service = try makeService()
        let sut = makeSut(service: service)

        await sut.loadDetail(personID: 31964)

        guard case .loaded(let detail) = sut.state else {
            Issue.record("Expected a loaded state")
            return
        }
        #expect(detail.knownFor.count == 8)
        #expect(service.fetchCallCount == 3)
    }

    @Test func viewModel_whenCreditsFail_isFailed() async {
        let sut = makeSut(service: MockTVMazeAPIService(error: TVMazeAPIServiceError.invalidResponse))

        await sut.loadDetail(personID: 31964)

        #expect(sut.state == .failed)
    }

    @Test func viewModel_whenDetailIsAlreadyLoaded_doesNotLoadAgain() async throws {
        let service = try makeService()
        let sut = makeSut(service: service)

        await sut.loadDetail(personID: 31964)
        await sut.loadDetail(personID: 31964)

        #expect(service.fetchCallCount == 3)
    }

    @Test func viewModel_withLivingPerson_countsTheAgeUntilNow() throws {
        let sut = makeSut(service: MockTVMazeAPIService())
        let now = try makeDate(year: 2026, month: 11, day: 10)

        let age = sut.age(of: try makePerson(deathday: nil), now: now)

        #expect(age == 53)
    }

    @Test func viewModel_withDeceasedPerson_countsTheAgeUntilTheirDeath() throws {
        let sut = makeSut(service: MockTVMazeAPIService())
        let now = try makeDate(year: 2026, month: 11, day: 10)

        let age = sut.age(of: try makePerson(deathday: try makeDate(year: 2000, month: 1, day: 1)), now: now)

        #expect(age == 26)
    }
}

extension PersonDetailViewModelTests {
    private func makeSut(service: TVMazeAPIService) -> PersonDetailViewModel {
        PersonDetailViewModel(service: service)
    }

    private func makeService() throws -> MockTVMazeAPIService {
        let service = MockTVMazeAPIService()
        service.castCredits = try Fixtures.decode([PersonCastCreditModel].self, named: "person_cast_credits_response")
        service.crewCredits = try Fixtures.decode([PersonCrewCreditModel].self, named: "person_crew_credits_response")
        service.guestCredits = try Fixtures.decode([PersonGuestCreditModel].self, named: "person_guest_credits_response")
        return service
    }

    private func makeDate(year: Int, month: Int, day: Int) throws -> Date {
        try #require(Calendar.current.date(from: DateComponents(year: year, month: month, day: day)))
    }

    private func makePerson(deathday: Date?) throws -> PersonItemModel {
        PersonItemModel(
            id: 31964,
            name: "Adam Scott",
            imageURL: nil,
            largeImageURL: nil,
            birthday: try makeDate(year: 1973, month: 4, day: 3),
            deathday: deathday,
            country: nil)
    }
}
