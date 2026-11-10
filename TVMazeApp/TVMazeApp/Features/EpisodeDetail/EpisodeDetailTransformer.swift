//
//  EpisodeDetailTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct EpisodeDetailTransformer {
    private let personTransformer = PersonTransformer()

    func transform(_ model: EpisodeDetailModel) -> EpisodeGuestsItemModel {
        EpisodeGuestsItemModel(
            cast: personTransformer.transformCredits(model.embedded.guestcast.map { ($0.person, $0.character.name) }),
            crew: personTransformer.transformCredits(model.embedded.guestcrew.map { ($0.person, $0.guestCrewType) }))
    }
}
