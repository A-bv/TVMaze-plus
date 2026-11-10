//
//  CrewSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct CrewSection: View {
    private enum Constants {
        static let title = String(localized: "Crew")
        static let showLessTitle = String(localized: "Show less")
        static let collapsedCount = 8
        static let rowPadding: CGFloat = 10
        static let spacing: CGFloat = 12
    }

    let crew: [CreditItemModel]

    @State private var isExpanded = false

    var body: some View {
        DetailSection(title: Constants.title) {
            VStack(spacing: 0) {
                ForEach(isExpanded ? crew : Array(crew.prefix(Constants.collapsedCount))) { credit in
                    HStack(alignment: .firstTextBaseline, spacing: Constants.spacing) {
                        Text(credit.person.name)
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        Text(credit.role)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.vertical, Constants.rowPadding)
                    .accessibilityElement(children: .combine)
                }
            }

            if crew.count > Constants.collapsedCount {
                Button(isExpanded ? Constants.showLessTitle : String(localized: "Show all \(crew.count)")) {
                    isExpanded.toggle()
                }
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .buttonStyle(NeumorphicButtonStyle())
            }
        }
    }
}
