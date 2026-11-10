//
//  EpisodesSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct EpisodesSection: View {
    private enum Constants {
        static let title = String(localized: "Episodes")
        static let emptyMessage = String(localized: "No episodes announced yet.")
        static let seasonTitle = String(localized: "Season")
        static let menuIcon = "chevron.up.chevron.down"
        static let chipLimit = 5
        static let seasonSpacing: CGFloat = 8
        static let seasonHorizontalPadding: CGFloat = 16
        static let seasonVerticalPadding: CGFloat = 9
        static let episodeSpacing: CGFloat = 16
    }

    let seasons: [SeasonItemModel]
    @Binding var selectedSeason: Int?
    let episodes: [EpisodeItemModel]
    let showName: String
    let fallbackImageURL: URL?

    var body: some View {
        DetailSection(title: Constants.title) {
            seasonPicker

            if episodes.isEmpty {
                Text(Constants.emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondaryText)
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

    @ViewBuilder
    private var seasonPicker: some View {
        if seasons.count > Constants.chipLimit {
            Menu {
                Picker(Constants.seasonTitle, selection: $selectedSeason) {
                    ForEach(seasons.reversed()) { season in
                        Text("Season \(String(season.number))")
                            .tag(season.number as Int?)
                    }
                }
            } label: {
                HStack(spacing: Constants.seasonSpacing) {
                    if let selectedSeason {
                        Text("Season \(String(selectedSeason))")
                    }
                    Image(systemName: Constants.menuIcon)
                }
                .modifier(SeasonChip(isSelected: true))
            }
        } else {
            HStack(spacing: Constants.seasonSpacing) {
                ForEach(seasons) { season in
                    Button {
                        selectedSeason = season.number
                    } label: {
                        Text("Season \(String(season.number))")
                            .modifier(SeasonChip(isSelected: selectedSeason == season.number))
                    }
                    .accessibilityAddTraits(selectedSeason == season.number ? .isSelected : [])
                }
            }
        }
    }

    private struct SeasonChip: ViewModifier {
        let isSelected: Bool

        func body(content: Content) -> some View {
            content
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                .padding(.horizontal, Constants.seasonHorizontalPadding)
                .padding(.vertical, Constants.seasonVerticalPadding)
                .glassEffect(.regular.interactive(), in: .capsule)
        }
    }
}
