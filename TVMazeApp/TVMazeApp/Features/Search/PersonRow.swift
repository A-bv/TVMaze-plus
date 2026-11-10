//
//  PersonRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct PersonRow: View {
    private enum Constants {
        static let imageSize: CGFloat = 56
        static let spacing: CGFloat = 14
        static let textSpacing: CGFloat = 4
        static let padding: CGFloat = 6
        static let separator = " · "
        static let placeholderIcon = "person.fill"
        static let chevronIcon = "chevron.right"
    }

    let person: PersonItemModel

    var body: some View {
        HStack(spacing: Constants.spacing) {
            PosterView(url: person.imageURL, placeholderIcon: Constants.placeholderIcon)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(person.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundStyle(.secondaryText)
                }
            }
            .multilineTextAlignment(.leading)

            Spacer(minLength: 0)

            Image(systemName: Constants.chevronIcon)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(Constants.padding)
    }

    private var details: String {
        [
            person.birthday.map { String(localized: "Born \($0.formatted(.dateTime.year()))") },
            person.country
        ]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}
