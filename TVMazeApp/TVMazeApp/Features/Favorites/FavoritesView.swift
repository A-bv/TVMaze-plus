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
        static let removeBadgeIcon = "minus.circle.fill"
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
        static let gridSpacing: CGFloat = 14
        static let rowSpacing: CGFloat = 14
        static let columnCount = 3
        static let posterAspectRatio: CGFloat = 2 / 3
        static let posterCornerRadius: CGFloat = 14
        static let chipPadding: CGFloat = 6
        static let badgeOffset: CGFloat = -8
        static let rowBadgePadding: CGFloat = 16
        static let weekDayCount = 6
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

    @Environment(\.modelContext) private var context
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
                .onChange(of: viewModel.refreshedShows) { _, shows in
                    refreshFavorites(with: shows)
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
                        case .grid: grid
                        case .list: list
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
                    Text(title(of: order))
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var sortedFavorites: [SavedShowModel] {
        viewModel.sorted(favorites, by: sortOrder)
    }

    private var grid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(spacing: Constants.gridSpacing), count: Constants.columnCount),
            spacing: Constants.gridSpacing
        ) {
            ForEach(sortedFavorites) { favorite in
                NavigationLink {
                    ShowDetailView(show: favorite.showItem)
                } label: {
                    PosterView(url: favorite.posterURL)
                        .aspectRatio(Constants.posterAspectRatio, contentMode: .fit)
                        .overlay(alignment: .bottomLeading) {
                            GlassChip(text: status(of: favorite))
                                .foregroundStyle(.white)
                                .padding(Constants.chipPadding)
                        }
                        .clipShape(.rect(cornerRadius: Constants.posterCornerRadius))
                        .neumorphicShadow()
                }
                .buttonStyle(.plain)
                .disabled(isEditing)
                .accessibilityLabel(favorite.name)
                .accessibilityValue(status(of: favorite, includesTime: true))
                .overlay(alignment: .topLeading) {
                    if isEditing {
                        removeButton(for: favorite)
                            .offset(x: Constants.badgeOffset, y: Constants.badgeOffset)
                    }
                }
                .contextMenu {
                    removeMenuButton(for: favorite)
                }
            }
        }
    }

    private var list: some View {
        LazyVStack(spacing: Constants.rowSpacing) {
            ForEach(sortedFavorites) { favorite in
                NavigationLink {
                    ShowDetailView(show: favorite.showItem)
                } label: {
                    ShowRow(show: favorite.showItem, detail: status(of: favorite, includesTime: true))
                }
                .buttonStyle(NeumorphicButtonStyle())
                .disabled(isEditing)
                .overlay(alignment: .trailing) {
                    if isEditing {
                        removeButton(for: favorite)
                            .padding(.trailing, Constants.rowBadgePadding)
                    }
                }
                .contextMenu {
                    removeMenuButton(for: favorite)
                }
            }
        }
    }

    private func removeButton(for favorite: SavedShowModel) -> some View {
        Button {
            withAnimation {
                context.delete(favorite)
            }
        } label: {
            Image(systemName: Constants.removeBadgeIcon)
                .font(.title2)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .red)
        }
        .accessibilityLabel("\(Constants.removeTitle), \(favorite.name)")
        .transition(.scale.combined(with: .opacity))
    }

    private func removeMenuButton(for favorite: SavedShowModel) -> some View {
        Button(Constants.removeTitle, systemImage: Constants.removeIcon, role: .destructive) {
            context.delete(favorite)
        }
    }

    private func status(of favorite: SavedShowModel, includesTime: Bool = false) -> String {
        guard let airDate = viewModel.nextAirDate(of: favorite.id) else { return favorite.status }
        let lastWeekDay = Calendar.current.date(byAdding: .day, value: Constants.weekDayCount, to: .now) ?? .now
        let day: Date.FormatStyle = airDate < lastWeekDay
            ? .dateTime.weekday(.abbreviated)
            : .dateTime.day().month(.abbreviated)
        return airDate.formatted(includesTime ? day.hour().minute() : day)
    }

    private func title(of order: FavoritesViewModel.SortOrder) -> String {
        switch order {
        case .dateAdded: String(localized: "Date added")
        case .nextEpisode: String(localized: "Next episode")
        case .name: String(localized: "Name")
        case .rating: String(localized: "Rating")
        }
    }

    private func refreshFavorites(with shows: [ShowItemModel]) {
        for show in shows {
            guard let favorite = favorites.first(where: { $0.id == show.id }), favorite.showItem != show else { continue }
            favorite.update(from: show)
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
