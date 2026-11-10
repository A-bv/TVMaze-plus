//
//  EpisodesSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct EpisodesSection: View {
    private enum Constants {
        static let title = String(localized: "Episodes")
        static let emptyMessage = String(localized: "No episodes announced yet.")
        static let seasonSpacing: CGFloat = 12
        static let episodeSpacing: CGFloat = 16
        static let shadowSpace: CGFloat = 10
    }

    let seasons: [SeasonItemModel]
    @Binding var selectedSeason: Int?
    let episodes: [EpisodeItemModel]
    let showName: String
    let fallbackImageURL: URL?

    var body: some View {
        DetailSection(title: Constants.title) {
            ScrollView(.horizontal) {
                HStack(spacing: Constants.seasonSpacing) {
                    ForEach(seasons) { season in
                        Toggle(isOn: Binding(
                            get: { selectedSeason == season.number },
                            set: { _ in selectedSeason = season.number }
                        )) {
                            Text("Season \(season.number)")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(selectedSeason == season.number ? Color.accentColor : Color.primary)
                        }
                        .toggleStyle(NeumorphicToggleStyle())
                    }
                }
                .padding(.vertical, Constants.shadowSpace)
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .defaultScrollAnchor(.trailing, for: .initialOffset)

            if episodes.isEmpty {
                Text(Constants.emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: Constants.episodeSpacing) {
                    ForEach(episodes) { episode in
                        NavigationLink {
                            EpisodeDetailView(
                                episode: episode,
                                episodes: seasons.flatMap(\.episodes),
                                showName: showName,
                                fallbackImageURL: fallbackImageURL)
                        } label: {
                            EpisodeRow(episode: episode)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
