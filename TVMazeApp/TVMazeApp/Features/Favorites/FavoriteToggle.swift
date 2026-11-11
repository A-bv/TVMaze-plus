//
//  FavoriteToggle.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftData
import SwiftUI

struct FavoriteToggle: View {
    private enum Constants {
        static let addTitle = String(localized: "Add to favorites")
        static let savedTitle = String(localized: "In favorites")
        static let addIcon = "heart"
        static let savedIcon = "heart.fill"
        static let minHeight: CGFloat = 44
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

        Toggle(isOn: Binding(
            get: { saved != nil },
            set: { _ in context.toggleFavorite(show, saved: saved) }
        )) {
            Label(
                saved == nil ? Constants.addTitle : Constants.savedTitle,
                systemImage: saved == nil ? Constants.addIcon : Constants.savedIcon)
                .font(.headline)
                .foregroundStyle(saved == nil ? Color.primary : Color.accentColor)
                .frame(maxWidth: .infinity, minHeight: Constants.minHeight)
        }
        .toggleStyle(NeumorphicToggleStyle())
    }
}
