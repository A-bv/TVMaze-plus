//
//  PersonItemModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct PersonItemModelTests {
    @Test func person_withBirthdayAndCountry_detailsBoth() {
        let birthday = Date(timeIntervalSince1970: 102_643_200)

        let details = makePerson(birthday: birthday, country: "United States").details

        #expect(details == "\(String(localized: "Born \(birthday.formatted(.dateTime.year()))")) · United States")
    }

    @Test func person_withOnlyCountry_detailsTheCountry() {
        #expect(makePerson(birthday: nil, country: "Canada").details == "Canada")
    }

    @Test func person_withoutBirthdayOrCountry_hasNoDetails() {
        #expect(makePerson(birthday: nil, country: nil).details.isEmpty)
    }
}

extension PersonItemModelTests {
    private func makePerson(birthday: Date?, country: String?) -> PersonItemModel {
        PersonItemModel(
            id: 1,
            name: "Adam Scott",
            imageURL: nil,
            largeImageURL: nil,
            birthday: birthday,
            deathday: nil,
            country: country)
    }
}
