//
//  AroundEpisodeSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct AroundEpisodeSection: View {
    private enum Constants {
        static let title = String(localized: "Around this episode")
        static let previousTitle = String(localized: "Previous")
        static let nextTitle = String(localized: "Next")
        static let spacing: CGFloat = 14
        static let textSpacing: CGFloat = 4
        static let imageAspectRatio: CGFloat = 16 / 9
        static let cornerRadius: CGFloat = 10
        static let lineLimit = 2
        static let separator = " · "
    }

    let previous: EpisodeItemModel?
    let next: EpisodeItemModel?
    let fallbackImageURL: URL?
    let select: (EpisodeItemModel) -> Void

    var body: some View {
        if previous != nil || next != nil {
            DetailSection(title: Constants.title) {
                HStack(alignment: .top, spacing: Constants.spacing) {
                    if let previous {
                        card(for: previous, label: Constants.previousTitle)
                    }
                    if let next {
                        card(for: next, label: Constants.nextTitle)
                    }
                }
            }
        }
    }

    private func card(for episode: EpisodeItemModel, label: String) -> some View {
        Button {
            select(episode)
        } label: {
            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                PosterView(url: episode.imageURL ?? fallbackImageURL)
                    .aspectRatio(Constants.imageAspectRatio, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: Constants.cornerRadius))
                Text("\(label)\(Constants.separator)\(episode.code)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(episode.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(Constants.lineLimit, reservesSpace: true)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(NeumorphicButtonStyle())
    }
}
