//
//  PersonDetailTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct PersonDetailTransformerTests {
    @Test func transformer_withRealCredits_transformsToExpectedData() throws {
        let sut = makeSut()

        let detail = sut.transform(
            castCredits: try Fixtures.decode([PersonCastCreditModel].self, named: "person_cast_credits_response"),
            crewCredits: try Fixtures.decode([PersonCrewCreditModel].self, named: "person_crew_credits_response"),
            guestCredits: try Fixtures.decode([PersonGuestCreditModel].self, named: "person_guest_credits_response"))

        #expect(detail.knownFor.count == 8)
        #expect(detail.knownFor.first?.show.name == "Parks and Recreation")
        #expect(detail.knownFor.first?.role == "Ben Wyatt")
        #expect(detail.behindTheCamera.map(\.show.name) == [
            "Ghosted", "Severance", "Party Down", "The Greatest Event in Television History", "Shifter"
        ])
        #expect(detail.behindTheCamera.first { $0.show.name == "Severance" }?.role == "Producer · Executive Producer")
        #expect(detail.showCount == 10)
        #expect(detail.guestAppearances.map(\.episode.name) == [
            "Battle of the Champions",
            "The Risky Business of Being Alone in Your Home",
            "Freddy Spaghetti",
            "The Master Plan"
        ])
        #expect(detail.guestAppearances.last?.showName == "Parks and Recreation")
        #expect(detail.guestAppearances.last?.character == "Ben Wyatt")
    }
}

extension PersonDetailTransformerTests {
    private func makeSut() -> PersonDetailTransformer {
        PersonDetailTransformer()
    }
}
