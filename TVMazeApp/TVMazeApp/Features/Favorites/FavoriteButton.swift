//
//  FavoriteButton.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftData
import SwiftUI

struct FavoriteButton: View {
    let show: ShowItemModel
    
    private enum Constants {
        static let buttonSize: CGFloat = 40
        static let backgroundOpacity: CGFloat = 0.3
        static let addIcon = "heart"
        static let removeIcon = "heart.fill"
        static let addAccessibilityLabel = String(localized: "Add to favorites")
        static let removeAccessibilityLabel = String(localized: "Remove from favorites")
    }

    @Environment(\.modelContext) private var context
    @Query private var favorites: [SavedShowModel]

    var body: some View {
        let saved = favorites.first(where: { $0.id == show.id })

        Button {
            if let saved {
                context.delete(saved)
            } else {
                context.insert(SavedShowModel(from: show))
            }
        } label: {
            Image(systemName: saved == nil ? Constants.addIcon : Constants.removeIcon)
                .font(.title2)
                .foregroundStyle(Color.primary)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                .background(.white.opacity(Constants.backgroundOpacity), in: Circle())
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .accessibilityLabel(saved == nil ? Constants.addAccessibilityLabel : Constants.removeAccessibilityLabel)
    }
}
