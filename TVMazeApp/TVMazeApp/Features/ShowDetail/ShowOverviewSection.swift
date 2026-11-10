//
//  ShowOverviewSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct ShowOverviewSection: View {
    private enum Constants {
        static let spacing: CGFloat = 20
        static let tileSpacing: CGFloat = 14
        static let ratingTitle = String(localized: "Rating")
        static let ratingIcon = "star.fill"
        static let episodesTitle = String(localized: "Episodes")
        static let runtimeTitle = String(localized: "Runtime")
        static let websiteTitle = String(localized: "Website")
        static let websiteIcon = "safari"
        static let shareTitle = String(localized: "Share")
        static let shareIcon = "square.and.arrow.up"
        static let missingValue = "–"
        static let iconSize: CGFloat = 44
    }

    let show: ShowItemModel
    let detail: ShowDetailItemModel?

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            if !show.genres.isEmpty {
                Text(show.genres)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: Constants.tileSpacing) {
                StatTile(title: Constants.ratingTitle, value: show.rating, icon: Constants.ratingIcon)
                StatTile(
                    title: Constants.episodesTitle,
                    value: detail.map { String($0.episodeCount) } ?? Constants.missingValue)
                StatTile(
                    title: Constants.runtimeTitle,
                    value: detail?.runtime?.runtimeText ?? Constants.missingValue)
            }

            HStack(spacing: Constants.tileSpacing) {
                FavoriteToggle(show: show)
                if let url = show.websiteURL {
                    Link(destination: url) {
                        Image(systemName: Constants.websiteIcon)
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                    }
                    .accessibilityLabel(Constants.websiteTitle)
                    ShareLink(item: url) {
                        Image(systemName: Constants.shareIcon)
                            .frame(width: Constants.iconSize, height: Constants.iconSize)
                    }
                    .accessibilityLabel(Constants.shareTitle)
                }
            }
            .font(.title3)
            .buttonStyle(NeumorphicButtonStyle())

            Text(show.summary)
                .font(.body)
        }
    }
}
