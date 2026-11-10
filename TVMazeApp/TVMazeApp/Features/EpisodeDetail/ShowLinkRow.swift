//
//  ShowLinkRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct ShowLinkRow: View {
    private enum Constants {
        static let title = String(localized: "See the show")
        static let icon = "chevron.forward"
        static let posterWidth: CGFloat = 40
        static let posterHeight: CGFloat = 56
        static let posterCornerRadius: CGFloat = 8
        static let spacing: CGFloat = 12
        static let textSpacing: CGFloat = 3
    }

    let show: ShowItemModel

    var body: some View {
        NavigationLink {
            ShowDetailView(show: show)
        } label: {
            HStack(spacing: Constants.spacing) {
                PosterView(url: show.posterURL)
                    .frame(width: Constants.posterWidth, height: Constants.posterHeight)
                    .clipShape(.rect(cornerRadius: Constants.posterCornerRadius))
                VStack(alignment: .leading, spacing: Constants.textSpacing) {
                    Text(Constants.title)
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                    Text(show.name)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: Constants.icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondaryText)
            }
        }
        .buttonStyle(NeumorphicButtonStyle())
        .accessibilityElement(children: .combine)
    }
}
