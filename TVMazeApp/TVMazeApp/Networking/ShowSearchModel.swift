//
//  ShowSearchModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 28.09.2026.
//

struct ShowSearchModel: Decodable, Equatable {
    let score: Double
    let show: Show
}

struct Show: Decodable, Equatable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String?
    let genres: [String]
    let status: String
    let runtime: Int?
    let averageRuntime: Int?
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let schedule: Schedule
    let rating: Rating
    let weight: Int
    let network: Network?
    let webChannel: WebChannel?
    let dvdCountry: Country?
    let externals: Externals
    let image: ShowImage?
    let summary: String?
    let updated: Int
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case type
        case language
        case genres
        case status
        case runtime
        case averageRuntime
        case premiered
        case ended
        case officialSite
        case schedule
        case rating
        case weight
        case network
        case webChannel
        case dvdCountry
        case externals
        case image
        case summary
        case updated
        case links = "_links"
    }
}

struct WebChannel: Decodable, Equatable {
    let id: Int
    let name: String
    let country: Country?
    let officialSite: String?
}

struct Network: Decodable, Equatable {
    let id: Int
    let name: String
    let country: Country
    let officialSite: String?
}

struct Country: Decodable, Equatable {
    let name: String
    let code: String
    let timezone: String
}

struct Externals: Decodable, Equatable {
    let tvrage: Int?
    let thetvdb: Int?
    let imdb: String?
}

struct ShowImage: Decodable, Equatable {
    let medium: String
    let original: String
}

struct Rating: Decodable, Equatable {
    let average: Double?
}

struct Schedule: Decodable, Equatable {
    let time: String
    let days: [String]
}

struct Links: Decodable, Equatable {
    let selfLink: SelfLink
    let previousEpisode: PreviousEpisode?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case previousEpisode = "previousepisode"
    }
}

struct SelfLink: Decodable, Equatable {
    let href: String
}

struct PreviousEpisode: Decodable, Equatable {
    let href: String
    let name: String
}
