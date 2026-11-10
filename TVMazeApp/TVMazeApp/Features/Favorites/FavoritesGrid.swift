//
//  FavoritesGrid.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct FavoritesGrid: View {
    private enum Constants {
        static let spacing: CGFloat = 14
        static let columnCount = 3
        static let posterAspectRatio: CGFloat = 2 / 3
        static let posterCornerRadius: CGFloat = 14
        static let chipPadding: CGFloat = 6
        static let badgeOffset: CGFloat = -8
    }

    let favorites: [SavedShowModel]
    let viewModel: FavoritesViewModel
    let isEditing: Bool

    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(spacing: Constants.spacing), count: Constants.columnCount),
            spacing: Constants.spacing
        ) {
            ForEach(favorites) { favorite in
                NavigationLink {
                    ShowDetailView(show: favorite.showItem)
                } label: {
                    PosterView(url: favorite.posterURL)
                        .aspectRatio(Constants.posterAspectRatio, contentMode: .fit)
                        .overlay(alignment: .bottomLeading) {
                            GlassChip(text: viewModel.status(of: favorite))
                                .foregroundStyle(.white)
                                .padding(Constants.chipPadding)
                        }
                        .clipShape(.rect(cornerRadius: Constants.posterCornerRadius))
                        .neumorphicShadow()
                }
                .buttonStyle(.plain)
                .disabled(isEditing)
                .accessibilityLabel(favorite.name)
                .accessibilityValue(viewModel.status(of: favorite, includesTime: true))
                .overlay(alignment: .topLeading) {
                    if isEditing {
                        RemoveFavoriteButton(favorite: favorite, style: .badge)
                            .offset(x: Constants.badgeOffset, y: Constants.badgeOffset)
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
