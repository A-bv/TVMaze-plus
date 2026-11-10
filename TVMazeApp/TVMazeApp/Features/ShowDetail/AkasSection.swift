//
//  AkasSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct AkasSection: View {
    private enum Constants {
        static let title = String(localized: "Also known as")
        static let spacing: CGFloat = 14
        static let textSpacing: CGFloat = 2
        static let padding: CGFloat = 12
        static let cornerRadius: CGFloat = 14
    }

    let akas: [AkaItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Constants.spacing), GridItem(.flexible())],
                spacing: Constants.spacing
            ) {
                ForEach(akas) { aka in
                    VStack(alignment: .leading, spacing: Constants.textSpacing) {
                        Text(aka.name)
                            .font(.subheadline.weight(.semibold))
                        if let country = aka.country {
                            Text(country)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Constants.padding)
                    .softTile(cornerRadius: Constants.cornerRadius)
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}
