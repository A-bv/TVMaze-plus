//
//  ShowSearchMainView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 26.09.2026.
//

import SwiftUI

struct ShowSearchMainView: View {
    private enum Constants {
        static let title = "TV Shows"
        static let searchPrompt = "Search a show"
        static let errorTitle = "Something went wrong"
        static let errorMessage = "Try again later."
        static let errorIcon = "exclamationmark.triangle"
        static let emptyTitle = "Search for a show"
        static let emptyMessage = "Type a show's name and press Search."
        static let emptyIcon = "tv"
    }
    
    @State private var viewModel = ShowSearchViewModel(service: TVMazeAPIServiceImpl())
    @State private var searchText = ""
    @State private var pendingSearch: String?

    var body: some View {
        NavigationStack {
            content
            .navigationTitle(Constants.title)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Constants.searchPrompt)
            .onSubmit(of: .search) {
                pendingSearch = searchText
            }
            .task(id: pendingSearch) {
                guard let entry = pendingSearch, !entry.isEmpty else { return }
                await viewModel.loadShows(entry: entry)
                if !Task.isCancelled { pendingSearch = nil }
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let shows, let entry) where shows.isEmpty:
            ContentUnavailableView.search(text: entry)
        case .loaded(let shows, _):
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(shows) { show in
                        NavigationLink {
                            ShowDetailView(show: show)
                        } label: {
                            CardView(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ShowSearchMainView()
}
