//
//  ShowRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct ShowRow: View {
    private enum Constants {
        static let posterWidth: CGFloat = 62
        static let posterHeight: CGFloat = 88
        static let cornerRadius: CGFloat = 10
        static let spacing: CGFloat = 14
        static let textSpacing: CGFloat = 4
        static let padding: CGFloat = 6
        static let trailingSpace: CGFloat = 44
        static let ratingIcon = "star.fill"
        static let ratingAccessibilityLabel = String(localized: "Rating")
    }

    let show: ShowItemModel

    var body: some View {
        HStack(spacing: Constants.spacing) {
            PosterView(url: show.posterURL)
                .frame(width: Constants.posterWidth, height: Constants.posterHeight)
                .clipShape(.rect(cornerRadius: Constants.cornerRadius))

            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(show.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(show.years)
                if let channel = show.channel {
                    Text(channel)
                }
                Label(show.rating, systemImage: Constants.ratingIcon)
                    .labelStyle(.titleAndIcon)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tint)
                    .accessibilityLabel("\(Constants.ratingAccessibilityLabel) \(show.rating)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)

            Spacer(minLength: Constants.trailingSpace)
        }
        .padding(Constants.padding)
    }
}
