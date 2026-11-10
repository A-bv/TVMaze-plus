//
//  ShowDetailModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct ShowDetailModel: Decodable, Equatable {
    let show: Show
    let embedded: ShowEmbedded

    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    init(from decoder: Decoder) throws {
        show = try Show(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedded = try container.decode(ShowEmbedded.self, forKey: .embedded)
    }
}

struct ShowEmbedded: Decodable, Equatable {
    let seasons: [Season]
    let episodes: [Episode]
    let cast: [CastCredit]
    let crew: [CrewCredit]
    let images: [GalleryImage]
    let akas: [Aka]
}

struct Season: Decodable, Equatable {
    let id: Int
    let number: Int
}

struct CastCredit: Decodable, Equatable {
    let person: Person
    let character: Character
}

struct Character: Decodable, Equatable {
    let name: String
}

struct CrewCredit: Decodable, Equatable {
    let type: String
    let person: Person
}

struct GalleryImage: Decodable, Equatable {
    let id: Int
    let type: String?
    let resolutions: Resolutions
}

struct Resolutions: Decodable, Equatable {
    let original: Resolution
}

struct Resolution: Decodable, Equatable {
    let url: String
}

struct Aka: Decodable, Equatable {
    let name: String
    let country: Country?
}
