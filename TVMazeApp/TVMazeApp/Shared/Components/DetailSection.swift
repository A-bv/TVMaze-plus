//
//  DetailSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct DetailSection<Content: View>: View {
    private enum Constants {
        static var spacing: CGFloat { 14 }
    }

    let title: String
    var icon: String?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Label {
                Text(title)
            } icon: {
                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.tint)
                }
            }
            .font(.title2.weight(.bold))
                .accessibilityAddTraits(.isHeader)
            content
        }
    }
}
