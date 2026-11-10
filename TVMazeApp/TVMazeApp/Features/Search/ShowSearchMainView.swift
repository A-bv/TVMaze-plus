//
//  ShowSearchMainView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 26.09.2026.
//

import NeumorphicSwiftUI
import SwiftData
import SwiftUI

struct ShowSearchMainView: View {
    private enum Constants {
        static let title = String(localized: "TV Shows")
        static let searchPrompt = String(localized: "Search a show")
        static let errorTitle = String(localized: "Something went wrong")
        static let errorMessage = String(localized: "Try a different search.")
        static let errorIcon = "exclamationmark.triangle"
        static let emptyTitle = String(localized: "Search for a show")
        static let emptyMessage = String(localized: "Type a show's name and press Search.")
        static let emptyIcon = "tv"
        static let rowSpacing: CGFloat = 14
        static let favoritePadding: CGFloat = 12
    }
    
    @State private var viewModel = ShowSearchViewModel()
    @State private var searchText = ""
    @State private var submittedSearch = ""

    var body: some View {
        NavigationStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.surface)
                .navigationTitle(Constants.title)
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Constants.searchPrompt)
                .onSubmit(of: .search) {
                    submittedSearch = searchText
                }
                .task(id: submittedSearch) {
                    await viewModel.loadShows(entry: submittedSearch)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            ContentUnavailableView(
                Constants.emptyTitle,
                systemImage: Constants.emptyIcon,
                description: Text(Constants.emptyMessage))
        case .failed:
            ContentUnavailableView(
                Constants.errorTitle,
                systemImage: Constants.errorIcon,
                description: Text(Constants.errorMessage))
        case .loading:
            ProgressView()
        case .loaded(let shows, let entry) where shows.isEmpty:
            ContentUnavailableView.search(text: entry)
        case .loaded(let shows, _):
            ScrollView {
                LazyVStack(spacing: Constants.rowSpacing) {
                    ForEach(shows) { show in
                        NavigationLink {
                            ShowDetailView(show: show)
                        } label: {
                            ShowRow(show: show)
                        }
                        .buttonStyle(NeumorphicButtonStyle())
                        .overlay(alignment: .trailing) {
                            FavoriteButton(show: show)
                                .padding(.trailing, Constants.favoritePadding)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ShowSearchMainView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
