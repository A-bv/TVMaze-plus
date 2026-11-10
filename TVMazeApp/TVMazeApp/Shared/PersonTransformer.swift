//
//  PersonTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct PersonTransformer {
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
        CreditGrouping.group(credits.map { ($0.person, $0.role) }, id: \.id).map { credit in
            CreditItemModel(person: transform(credit.owner), role: credit.role)
        }
    }

    private func makeDay(_ day: String?) -> Date? {
        guard let day else { return nil }
        return try? Date.ISO8601FormatStyle(timeZone: .current).year().month().day().parse(day)
    }
}
