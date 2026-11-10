//
//  RemoveFavoriteButton.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import SwiftData
import SwiftUI

struct RemoveFavoriteButton: View {
    private enum Constants {
        static let title = String(localized: "Remove from favorites")
        static let icon = "heart.slash"
        static let badgeIcon = "minus.circle.fill"
    }

    enum Style {
        case menu
        case badge
    }

    let favorite: SavedShowModel
    var style = Style.menu

    @Environment(\.modelContext) private var context

    var body: some View {
        switch style {
        case .menu:
            Button(Constants.title, systemImage: Constants.icon, role: .destructive) {
                context.delete(favorite)
            }
        case .badge:
            Button {
                withAnimation {
                    context.delete(favorite)
                }
            } label: {
                Image(systemName: Constants.badgeIcon)
                    .font(.title2)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .red)
            }
            .accessibilityLabel("\(Constants.title), \(favorite.name)")
        }
    }
}
