//
//  EpisodeModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct Episode: Decodable, Equatable {
    let id: Int
    let name: String
    let season: Int
    let number: Int?
    let airdate: String?
    let airstamp: String?
    let runtime: Int?
    let rating: Rating
    let image: ImageLinks?
    let summary: String?
}

struct EpisodeDetailModel: Decodable, Equatable {
    let episode: Episode
    let embedded: EpisodeEmbedded

    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    init(from decoder: Decoder) throws {
        episode = try Episode(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedded = try container.decode(EpisodeEmbedded.self, forKey: .embedded)
    }
}

struct EpisodeEmbedded: Decodable, Equatable {
    let guestcast: [CastCredit]
    let guestcrew: [GuestCrewCredit]
}

struct GuestCrewCredit: Decodable, Equatable {
    let guestCrewType: String
    let person: Person
}
