//
//  FavoritesView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    private enum Constants {
        static let title = String(localized: "Favorites")
        static let showsTitle = String(localized: "Your shows")
        static let editTitle = String(localized: "Edit")
        static let doneTitle = String(localized: "Done")
        static let optionsTitle = String(localized: "View options")
        static let optionsIcon = "line.3.horizontal.decrease"
        static let layoutTitle = String(localized: "Layout")
        static let sortTitle = String(localized: "Sort by")
        static let emptyTitle = String(localized: "No favorites yet")
        static let emptyMessage = String(localized: "Tap the heart on a show to keep it here.")
        static let emptyIcon = "heart"
        static let sectionSpacing: CGFloat = 32
    }

    enum Layout: String, CaseIterable, Identifiable {
        case grid
        case list

        var id: Self { self }

        var title: String {
            switch self {
            case .grid: String(localized: "Grid")
            case .list: String(localized: "List")
            }
        }

        var icon: String {
            switch self {
            case .grid: "square.grid.3x2"
            case .list: "list.bullet"
            }
        }
    }

    @Query(sort: \SavedShowModel.savedAt, order: .reverse) private var favorites: [SavedShowModel]
    @State private var viewModel = FavoritesViewModel()
    @State private var isEditing = false
    @AppStorage("favoritesLayout") private var layout = Layout.grid
    @AppStorage("favoritesSortOrder") private var sortOrder = FavoritesViewModel.SortOrder.dateAdded

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.surface)
                .navigationTitle(Constants.title)
                .toolbar {
                    if !favorites.isEmpty {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(isEditing ? Constants.doneTitle : Constants.editTitle) {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            optionsMenu
                        }
                    }
                }
                .task(id: favorites.map(\.id)) {
                    await viewModel.loadUpNext(showIDs: favorites.map(\.id))
                }
                .onChange(of: viewModel.refreshedShows) {
                    viewModel.refresh(favorites)
                }
                .onChange(of: favorites.isEmpty) { _, isEmpty in
                    if isEmpty {
                        isEditing = false
                    }
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
                    DetailSection(title: Constants.showsTitle) {
                        switch layout {
                        case .grid:
                            FavoritesGrid(favorites: sortedFavorites, viewModel: viewModel, isEditing: isEditing)
                        case .list:
                            FavoritesList(favorites: sortedFavorites, viewModel: viewModel, isEditing: isEditing)
                        }
                    }
                    AttributionFooter()
                }
                .padding()
            }
        }
    }

    private var optionsMenu: some View {
        Menu(Constants.optionsTitle, systemImage: Constants.optionsIcon) {
            Picker(Constants.layoutTitle, selection: $layout.animation()) {
                ForEach(Layout.allCases) { layout in
                    Label(layout.title, systemImage: layout.icon)
                }
            }
            .pickerStyle(.inline)
            Picker(Constants.sortTitle, selection: $sortOrder.animation()) {
                ForEach(FavoritesViewModel.SortOrder.allCases) { order in
                    Text(order.title)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var sortedFavorites: [SavedShowModel] {
        viewModel.sorted(favorites, by: sortOrder)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
