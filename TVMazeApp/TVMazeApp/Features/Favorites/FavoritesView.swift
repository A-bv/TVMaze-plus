//
//  FavoritesView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import NeumorphicSwiftUI
import SwiftData
import SwiftUI

struct FavoritesView: View {
    private enum Constants {
        static let title = String(localized: "Favorites")
        static let showsTitle = String(localized: "Your shows")
        static let removeTitle = String(localized: "Remove from favorites")
        static let removeIcon = "heart.slash"
        static let emptyTitle = String(localized: "No favorites yet")
        static let emptyMessage = String(localized: "Tap the heart on a show to keep it here.")
        static let emptyIcon = "heart"
        static let sectionSpacing: CGFloat = 32
        static let gridSpacing: CGFloat = 14
        static let columnCount = 3
        static let posterAspectRatio: CGFloat = 2 / 3
        static let posterCornerRadius: CGFloat = 14
    }

    @Environment(\.modelContext) private var context
    @Query(sort: \SavedShowModel.savedAt, order: .reverse) private var favorites: [SavedShowModel]
    @State private var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.surface)
                .navigationTitle(Constants.title)
                .task(id: favorites.map(\.id)) {
                    await viewModel.loadUpNext(showIDs: favorites.map(\.id))
                }
                .onChange(of: viewModel.refreshedShows) { _, shows in
                    refreshFavorites(with: shows)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if favorites.isEmpty {
            ContentUnavailableView(
                Constants.emptyTitle,
                systemImage: Constants.emptyIcon,
                description: Text(Constants.emptyMessage))
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    if !viewModel.upNext.isEmpty {
                        UpNextSection(upNext: viewModel.upNext)
                    }
                    showsSection
                    AttributionFooter()
                }
                .padding()
            }
        }
    }

    private func refreshFavorites(with shows: [ShowItemModel]) {
        for show in shows {
            guard let favorite = favorites.first(where: { $0.id == show.id }), favorite.showItem != show else { continue }
            favorite.update(from: show)
        }
    }

    private var showsSection: some View {
        DetailSection(title: Constants.showsTitle) {
            LazyVGrid(
                columns: Array(repeating: GridItem(spacing: Constants.gridSpacing), count: Constants.columnCount),
                spacing: Constants.gridSpacing
            ) {
                ForEach(favorites) { favorite in
                    NavigationLink {
                        ShowDetailView(show: favorite.showItem)
                    } label: {
                        PosterView(url: favorite.posterURL)
                            .aspectRatio(Constants.posterAspectRatio, contentMode: .fit)
                            .clipShape(.rect(cornerRadius: Constants.posterCornerRadius))
                            .neumorphicShadow()
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(favorite.name)
                    .contextMenu {
                        Button(Constants.removeTitle, systemImage: Constants.removeIcon, role: .destructive) {
                            context.delete(favorite)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
