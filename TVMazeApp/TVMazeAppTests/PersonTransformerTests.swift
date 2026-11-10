//
//  PersonTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct PersonTransformerTests {
    @Test func transformer_withRealPerson_transformsToExpectedData() throws {
        let sut = makeSut()
        let person = try #require(Fixtures.decode([PersonSearchModel].self, named: "people_search_response").dropFirst().first).person

        let transformedPerson = sut.transform(person)

        let expectedBirthday = Calendar.current.date(from: DateComponents(year: 1973, month: 4, day: 3))
        #expect(transformedPerson.name == "Adam Scott")
        #expect(transformedPerson.birthday == expectedBirthday)
        #expect(transformedPerson.deathday == nil)
        #expect(transformedPerson.country == "United States")
        #expect(transformedPerson.imageURL?.absoluteString.contains("medium_portrait") == true)
    }

    @Test func transformer_withPersonInManyCredits_groupsTheirRoles() {
        let sut = makeSut()
        let first = makePerson(id: 1)
        let second = makePerson(id: 2)

        let credits = sut.transformCredits([
            (first, "Executive Producer"),
            (second, "Writer"),
            (first, "Producer"),
            (first, "Producer")
        ])

        #expect(credits.map(\.person.id) == [1, 2])
        #expect(credits.map(\.role) == ["Executive Producer · Producer", "Writer"])
    }
}

extension PersonTransformerTests {
    private func makeSut() -> PersonTransformer {
        PersonTransformer()
    }

    private func makePerson(id: Int) -> Person {
        Person(id: id, name: "name", country: nil, birthday: nil, deathday: nil, image: nil)
    }
}
