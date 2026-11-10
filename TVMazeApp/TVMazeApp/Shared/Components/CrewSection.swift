//
//  CrewSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct CrewSection: View {
    private enum Constants {
        static let title = String(localized: "Crew")
        static let collapsedCount = 8
    }

    let crew: [CreditItemModel]

    @State private var isExpanded = false

    var body: some View {
        DetailSection(title: Constants.title) {
            VStack(spacing: 0) {
                ForEach(isExpanded ? crew : Array(crew.prefix(Constants.collapsedCount))) { credit in
                    NavigationLink {
                        PersonDetailView(person: credit.person)
                    } label: {
                        CreditRow(name: credit.person.name, role: credit.role)
                    }
                    .buttonStyle(.plain)
                }
            }

            if crew.count > Constants.collapsedCount {
                ShowAllButton(count: crew.count, isExpanded: $isExpanded)
            }
        }
    }
}
