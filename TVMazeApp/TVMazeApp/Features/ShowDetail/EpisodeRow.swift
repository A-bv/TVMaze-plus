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
        static let separator = " · "
        static let ratingIcon = "star.fill"
        static let ratingAccessibilityLabel = String(localized: "Rating")
    }

    let episode: EpisodeItemModel

    var body: some View {
        HStack(spacing: Constants.spacing) {
            thumbnail
                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                .clipShape(.rect(cornerRadius: Constants.cornerRadius))

            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primary)
                if !details.isEmpty {
                    Text(details)
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
                    Text(episode.number.map(String.init) ?? "")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.secondaryText)
                }
        }
    }

    private var title: String {
        guard let number = episode.number else { return episode.name }
        return "\(number)\(Constants.separator)\(episode.name)"
    }

    private var details: String {
        [
            episode.airDate?.formatted(date: .abbreviated, time: .omitted),
            episode.runtime?.runtimeText
        ]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}
