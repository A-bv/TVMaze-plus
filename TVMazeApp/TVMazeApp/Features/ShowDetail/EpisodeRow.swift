//
//  EpisodeRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct EpisodeRow: View {
    private enum Constants {
        static let imageWidth: CGFloat = 104
        static let imageHeight: CGFloat = 60
        static let cornerRadius: CGFloat = 10
        static let spacing: CGFloat = 14
        static let textSpacing: CGFloat = 3
        static let ratingIcon = "star.fill"
        static let placeholderIcon = "tv"
        static let ratingAccessibilityLabel = String(localized: "Rating")
    }

    let episode: EpisodeItemModel

    var body: some View {
        HStack(spacing: Constants.spacing) {
            thumbnail
                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                .clipShape(.rect(cornerRadius: Constants.cornerRadius))

            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(episode.numberedName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primary)
                if !episode.details.isEmpty {
                    Text(episode.details)
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                }
                if let rating = episode.rating {
                    Label(rating, systemImage: Constants.ratingIcon)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tint)
                        .accessibilityLabel("\(Constants.ratingAccessibilityLabel) \(rating)")
                }
            }
            .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var thumbnail: some View {
        if episode.imageURL != nil {
            PosterView(url: episode.imageURL)
        } else {
            LinearGradient(
                colors: [.surfaceGradientStart, .surfaceGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .overlay {
                    Image(systemName: Constants.placeholderIcon)
                        .font(.title3)
                        .foregroundStyle(.secondaryText)
                        .accessibilityHidden(true)
                }
        }
    }
}
