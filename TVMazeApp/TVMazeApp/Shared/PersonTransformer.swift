//
//  PersonTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct PersonTransformer {
    private enum Constants {
        static let roleSeparator = " · "
    }

    func transform(_ person: Person) -> PersonItemModel {
        PersonItemModel(
            id: person.id,
            name: person.name,
            imageURL: person.image.flatMap { URL(string: $0.medium) },
            largeImageURL: person.image.flatMap { URL(string: $0.original) },
            birthday: makeDay(person.birthday),
            deathday: makeDay(person.deathday),
            country: person.country?.name)
    }

    func transformCredits(_ credits: [(person: Person, role: String)]) -> [CreditItemModel] {
        var people: [Person] = []
        var roles: [Int: [String]] = [:]
        for credit in credits {
            if roles[credit.person.id] == nil {
                people.append(credit.person)
            }
            if roles[credit.person.id]?.contains(credit.role) != true {
                roles[credit.person.id, default: []].append(credit.role)
            }
        }
        return people.map { person in
            CreditItemModel(
                person: transform(person),
                role: roles[person.id, default: []].joined(separator: Constants.roleSeparator))
        }
    }

    private func makeDay(_ day: String?) -> Date? {
        guard let day else { return nil }
        return try? Date.ISO8601FormatStyle(timeZone: .current).year().month().day().parse(day)
    }
}
