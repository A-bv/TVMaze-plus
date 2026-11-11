//
//  PersonItemModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct PersonItemModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL?
    let largeImageURL: URL?
    let birthday: Date?
    let deathday: Date?
    let country: String?

    var details: String {
        [birthday.map { String(localized: "Born \($0.formatted(.dateTime.year()))") }, country]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}

struct CreditItemModel: Identifiable, Equatable {
    let person: PersonItemModel
    let role: String

    var id: Int { person.id }
}
