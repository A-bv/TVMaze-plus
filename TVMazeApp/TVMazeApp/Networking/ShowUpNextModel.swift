//
//  ShowUpNextModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct ShowUpNextModel: Decodable, Equatable {
    let show: Show
    let embedded: UpNextEmbedded

    private enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }

    init(from decoder: Decoder) throws {
        show = try Show(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedded = try container.decode(UpNextEmbedded.self, forKey: .embedded)
    }
}

struct UpNextEmbedded: Decodable, Equatable {
    let nextepisode: Episode?
    let images: [GalleryImage]
}
