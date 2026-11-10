//
//  GuestAppearancesSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct GuestAppearancesSection: View {
    private enum Constants {
        static let title = String(localized: "Guest appearances")
        static let collapsedCount = 6
        static let spacing: CGFloat = 16
        static let textSpacing: CGFloat = 3
        static let separator = " · "
    }

    let appearances: [GuestAppearanceItemModel]

    @State private var isExpanded = false

    var body: some View {
        DetailSection(title: Constants.title) {
            VStack(alignment: .leading, spacing: Constants.spacing) {
                ForEach(isExpanded ? appearances : Array(appearances.prefix(Constants.collapsedCount))) { appearance in
                    VStack(alignment: .leading, spacing: Constants.textSpacing) {
                        Text(appearance.episode.name)
                            .font(.subheadline.weight(.semibold))
                        Text(details(of: appearance))
                            .font(.caption)
                            .foregroundStyle(.secondaryText)
                        Text("as \(appearance.character)")
                            .font(.caption)
                            .foregroundStyle(.tint)
                    }
                    .accessibilityElement(children: .combine)
                }
            }

            if appearances.count > Constants.collapsedCount {
                ShowAllButton(count: appearances.count, isExpanded: $isExpanded)
            }
        }
    }

    private func details(of appearance: GuestAppearanceItemModel) -> String {
        [
            appearance.showName,
            appearance.episode.code,
            appearance.episode.airDate?.formatted(date: .abbreviated, time: .omitted)
        ]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}
