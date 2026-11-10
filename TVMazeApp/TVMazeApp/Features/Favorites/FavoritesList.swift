//
//  FavoritesList.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct FavoritesList: View {
    private enum Constants {
        static let spacing: CGFloat = 14
        static let badgePadding: CGFloat = 16
    }

    let favorites: [SavedShowModel]
    let viewModel: FavoritesViewModel
    let isEditing: Bool

    var body: some View {
        LazyVStack(spacing: Constants.spacing) {
            ForEach(favorites) { favorite in
                NavigationLink {
                    ShowDetailView(show: favorite.showItem)
                } label: {
                    ShowRow(show: favorite.showItem, detail: viewModel.status(of: favorite, includesTime: true))
                }
                .buttonStyle(NeumorphicButtonStyle())
                .disabled(isEditing)
                .overlay(alignment: .trailing) {
                    if isEditing {
                        RemoveFavoriteButton(favorite: favorite, style: .badge)
                            .padding(.trailing, Constants.badgePadding)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .contextMenu {
                    RemoveFavoriteButton(favorite: favorite)
                }
            }
        }
    }
}
