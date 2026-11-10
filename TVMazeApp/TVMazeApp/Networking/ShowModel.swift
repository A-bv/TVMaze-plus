//
//  ShowModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct Show: Decodable, Equatable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String?
    let genres: [String]
    let status: String
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: ShowSchedule
    let rating: Rating
    let weight: Int
    let network: Channel?
    let webChannel: Channel?
    let image: ImageLinks?
    let summary: String?
    let updated: Int
}

struct ShowSchedule: Decodable, Equatable {
    let time: String
    let days: [String]
}

struct Channel: Decodable, Equatable {
    let name: String
    let country: Country?
}

struct Country: Decodable, Equatable {
    let name: String
    let code: String
    let timezone: String
}

struct ImageLinks: Decodable, Equatable {
    let medium: String
    let original: String
}

struct Rating: Decodable, Equatable {
    let average: Double?
}
