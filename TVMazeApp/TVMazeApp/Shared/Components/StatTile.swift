//
//  StatTile.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct StatTile: View {
    private enum Constants {
        static let spacing: CGFloat = 4
        static let verticalPadding: CGFloat = 14
        static let horizontalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 18
        static let minimumScaleFactor: CGFloat = 0.6
    }

    let title: String
    let value: String
    var icon: String?

    @ScaledMetric(relativeTo: .title3) private var valueHeight: CGFloat = 25

    var body: some View {
        VStack(spacing: Constants.spacing) {
            HStack(spacing: Constants.spacing) {
                if let icon {
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(.tint)
                }
                Text(value)
                    .font(.title3.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(Constants.minimumScaleFactor)
            }
            .frame(height: valueHeight)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondaryText)
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .frame(maxWidth: .infinity)
        .padding(.vertical, Constants.verticalPadding)
        .softTile(cornerRadius: Constants.cornerRadius)
        .accessibilityElement(children: .combine)
    }
}
