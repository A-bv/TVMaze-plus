//
//  UpNextTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct UpNextTransformer {
    private enum Constants {
        static let backgroundImageType = "background"
    }

    private let showTransformer = ShowTransformer()
    private let episodeTransformer = EpisodeTransformer()

    func transform(_ upNext: ShowUpNextModel) -> UpNextItemModel? {
        guard let nextEpisode = upNext.embedded.nextepisode else { return nil }
        let show = showTransformer.transform(upNext.show)
        let episode = episodeTransformer.transform(nextEpisode)
        guard let airDate = episode.airDate else { return nil }
        let background = upNext.embedded.images.last { $0.type == Constants.backgroundImageType }

        return UpNextItemModel(
            show: show,
            episode: episode,
            airDate: airDate,
            backgroundURL: background.flatMap { URL(string: $0.resolutions.original.url) } ?? show.largePosterURL)
    }
}
