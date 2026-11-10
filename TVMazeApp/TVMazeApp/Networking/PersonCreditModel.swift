//
//  PersonCreditModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct PersonCastCreditModel: Decodable, Equatable {
    let links: CharacterLinks
    let embedded: EmbeddedShow

    private enum CodingKeys: String, CodingKey {
        case links = "_links"
        case embedded = "_embedded"
    }
}

struct PersonCrewCreditModel: Decodable, Equatable {
    let type: String
    let embedded: EmbeddedShow

    private enum CodingKeys: String, CodingKey {
        case type
        case embedded = "_embedded"
    }
}

struct PersonGuestCreditModel: Decodable, Equatable {
    let links: CharacterLinks
    let embedded: EmbeddedEpisode

    private enum CodingKeys: String, CodingKey {
        case links = "_links"
        case embedded = "_embedded"
    }
}

struct CharacterLinks: Decodable, Equatable {
    let character: NamedLink
}

struct NamedLink: Decodable, Equatable {
    let name: String
}

struct EmbeddedShow: Decodable, Equatable {
    let show: Show
}

struct EmbeddedEpisode: Decodable, Equatable {
    let episode: GuestEpisode
}

struct GuestEpisode: Decodable, Equatable {
    let episode: Episode
    let links: ShowLinks

    private enum CodingKeys: String, CodingKey {
        case links = "_links"
    }

    init(from decoder: Decoder) throws {
        episode = try Episode(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        links = try container.decode(ShowLinks.self, forKey: .links)
    }
}

struct ShowLinks: Decodable, Equatable {
    let show: NamedLink
}
