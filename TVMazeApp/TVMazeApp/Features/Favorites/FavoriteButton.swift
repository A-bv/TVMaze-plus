//
//  FavoriteButton.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftData
import SwiftUI

struct FavoriteButton: View {
    private enum Constants {
        static let buttonSize: CGFloat = 44
        static let addIcon = "heart"
        static let removeIcon = "heart.fill"
        static let addAccessibilityLabel = String(localized: "Add to favorites")
        static let removeAccessibilityLabel = String(localized: "Remove from favorites")
    }

    let show: ShowItemModel

    @Environment(\.modelContext) private var context
    @Query private var favorites: [SavedShowModel]

    init(show: ShowItemModel) {
        self.show = show
        _favorites = Query(filter: SavedShowModel.matching(show))
    }

    var body: some View {
        let saved = favorites.first

        Button {
            context.toggleFavorite(show, saved: saved)
        } label: {
            Image(systemName: saved == nil ? Constants.addIcon : Constants.removeIcon)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                .contentShape(.rect)
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .accessibilityLabel(saved == nil ? Constants.addAccessibilityLabel : Constants.removeAccessibilityLabel)
    }
}
