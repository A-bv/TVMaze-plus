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

    var body: some View {
        let saved = favorites.first(where: { $0.id == show.id })

        Toggle(isOn: Binding(
            get: { saved != nil },
            set: { isOn in
                if isOn {
                    context.insert(SavedShowModel(from: show))
                } else if let saved {
                    context.delete(saved)
                }
            }
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
