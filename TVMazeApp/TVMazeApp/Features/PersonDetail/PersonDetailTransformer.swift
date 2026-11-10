//
//  PersonDetailTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct PersonDetailTransformer {
    private let showTransformer = ShowTransformer()
    private let episodeTransformer = EpisodeTransformer()

    func transform(
        castCredits: [PersonCastCreditModel],
        crewCredits: [PersonCrewCreditModel],
        guestCredits: [PersonGuestCreditModel]
    ) -> PersonDetailItemModel {
        let knownFor = groupByShow(castCredits.map { ($0.embedded.show, $0.links.character.name) })
        let behindTheCamera = groupByShow(crewCredits.map { ($0.embedded.show, $0.type) })

        return PersonDetailItemModel(
            knownFor: knownFor,
            behindTheCamera: behindTheCamera,
            guestAppearances: transformGuestCredits(guestCredits),
            showCount: Set((knownFor + behindTheCamera).map(\.id)).count)
    }

    private func groupByShow(_ credits: [(owner: Show, role: String)]) -> [ShowCreditItemModel] {
        CreditGrouping.group(credits, id: \.id).map { credit in
            ShowCreditItemModel(show: showTransformer.transform(credit.owner), role: credit.role)
        }
    }

    private func transformGuestCredits(_ credits: [PersonGuestCreditModel]) -> [GuestAppearanceItemModel] {
        var seenEpisodes: Set<Int> = []
        return credits
            .filter { seenEpisodes.insert($0.embedded.episode.episode.id).inserted }
            .map { credit in
                GuestAppearanceItemModel(
                    episode: episodeTransformer.transform(credit.embedded.episode.episode),
                    showName: credit.embedded.episode.links.show.name,
                    character: credit.links.character.name)
            }
            .sorted { ($0.episode.airDate ?? .distantPast) > ($1.episode.airDate ?? .distantPast) }
    }
}
