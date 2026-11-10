//
//  ShowDetailTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct ShowDetailTransformer {
    private enum Constants {
        static let galleryImageType = "background"
    }

    private let episodeTransformer = EpisodeTransformer()
    private let personTransformer = PersonTransformer()

    func transform(_ model: ShowDetailModel) -> ShowDetailItemModel {
        let embedded = model.embedded
        let episodes = embedded.episodes.map(episodeTransformer.transform)

        return ShowDetailItemModel(
            runtime: model.show.averageRuntime,
            episodeCount: episodes.count,
            seasons: embedded.seasons.map { season in
                SeasonItemModel(number: season.number, episodes: episodes.filter { $0.season == season.number })
            },
            cast: personTransformer.transformCredits(embedded.cast.map { ($0.person, $0.character.name) }),
            crew: personTransformer.transformCredits(embedded.crew.map { ($0.person, $0.type) }),
            gallery: embedded.images
                .filter { $0.type == Constants.galleryImageType }
                .compactMap { image in
                    URL(string: image.resolutions.original.url).map { GalleryItemModel(id: image.id, url: $0) }
                },
            akas: embedded.akas.map { AkaItemModel(name: $0.name, country: $0.country?.name) })
    }
}
