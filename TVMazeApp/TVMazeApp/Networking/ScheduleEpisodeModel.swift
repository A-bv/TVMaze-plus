//
//  ScheduleEpisodeModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct ScheduleEpisodeModel: Decodable, Equatable {
    let episode: Episode
    let show: Show

    private enum CodingKeys: String, CodingKey {
        case show
        case embedded = "_embedded"
    }

    init(from decoder: Decoder) throws {
        episode = try Episode(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let show = try container.decodeIfPresent(Show.self, forKey: .show) {
            self.show = show
        } else {
            show = try container.decode(EmbeddedShow.self, forKey: .embedded).show
        }
    }
}
