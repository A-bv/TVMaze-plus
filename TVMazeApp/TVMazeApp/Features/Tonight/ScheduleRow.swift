//
//  ScheduleRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct ScheduleRow: View {
    private enum Constants {
        static let posterWidth: CGFloat = 48
        static let posterHeight: CGFloat = 68
        static let posterCornerRadius: CGFloat = 10
        static let spacing: CGFloat = 12
        static let textSpacing: CGFloat = 3
        static let separator = " · "
    }

    let entry: ScheduleItemModel

    var body: some View {
        HStack(spacing: Constants.spacing) {
            PosterView(url: entry.show.posterURL)
                .frame(width: Constants.posterWidth, height: Constants.posterHeight)
                .clipShape(.rect(cornerRadius: Constants.posterCornerRadius))
                .neumorphicShadow()
            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(entry.show.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(verbatim: "\(entry.episode.code)\(Constants.separator)\(entry.episode.name)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                if let channel = entry.show.channel {
                    Text(channel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}
