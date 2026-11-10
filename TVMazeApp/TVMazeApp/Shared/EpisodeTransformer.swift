//
//  EpisodeTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct EpisodeTransformer {
    func transform(_ episode: Episode) -> EpisodeItemModel {
        EpisodeItemModel(
            id: episode.id,
            name: episode.name,
            season: episode.season,
            number: episode.number,
            airDate: episode.airstamp.flatMap { try? Date($0, strategy: .iso8601) },
            runtime: episode.runtime,
            rating: episode.rating.average.map { String(format: "%.1f", $0) },
            imageURL: episode.image.flatMap { URL(string: $0.medium) },
            largeImageURL: episode.image.flatMap { URL(string: $0.original) },
            summary: cleanSummary(htmlSummary: episode.summary))
    }

    private func cleanSummary(htmlSummary: String?) -> String? {
        guard let summary = htmlSummary?.strippingHTML(), !summary.isEmpty else {
            return nil
        }
        return summary
    }
}
