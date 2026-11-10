//
//  SearchView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 26.09.2026.
//

import NeumorphicSwiftUI
import SwiftData
import SwiftUI

struct SearchView: View {
    private enum Constants {
        static let title = String(localized: "Search")
        static let showsPrompt = String(localized: "Search a show")
        static let peoplePrompt = String(localized: "Search a person")
        static let showsScope = String(localized: "Shows")
        static let peopleScope = String(localized: "People")
        static let errorTitle = String(localized: "Something went wrong")
        static let errorMessage = String(localized: "Try a different search.")
        static let errorIcon = "exclamationmark.triangle"
        static let emptyTitle = String(localized: "Search for a show")
        static let emptyMessage = String(localized: "Type a show's name and press Search.")
        static let emptyIcon = "tv"
        static let emptyPeopleTitle = String(localized: "Search for a person")
        static let emptyPeopleMessage = String(localized: "Type a person's name and press Search.")
        static let emptyPeopleIcon = "person"
        static let rowSpacing: CGFloat = 14
        static let scopeSpacing: CGFloat = 12
        static let favoritePadding: CGFloat = 12
    }
    
    @State private var viewModel = SearchViewModel()
    @State private var searchText = ""
    @State private var submittedSearch = ""
    @State private var scope = SearchViewModel.SearchScope.shows

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                scopePicker
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.surface)
            .navigationTitle(Constants.title)
            .searchable(text: $searchText, prompt: scope == .shows ? Constants.showsPrompt : Constants.peoplePrompt)
            .onSubmit(of: .search) {
                submittedSearch = searchText
            }
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    submittedSearch = ""
                }
            }
            .task(id: SearchQuery(entry: submittedSearch, scope: scope)) {
                await viewModel.search(entry: submittedSearch, scope: scope)
            }
        }
    }

    private var scopePicker: some View {
        HStack(spacing: Constants.scopeSpacing) {
            ForEach(SearchViewModel.SearchScope.allCases, id: \.self) { option in
                Toggle(isOn: Binding(
                    get: { scope == option },
                    set: { _ in scope = option }
                )) {
                    Text(option == .shows ? Constants.showsScope : Constants.peopleScope)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(scope == option ? Color.accentColor : Color.primary)
                        .frame(maxWidth: .infinity)
                }
                .toggleStyle(NeumorphicToggleStyle())
            }
        }
        .padding()
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle where scope == .people:
            ContentUnavailableView(
                Constants.emptyPeopleTitle,
                systemImage: Constants.emptyPeopleIcon,
                description: Text(Constants.emptyPeopleMessage))
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
        case .loadedPeople(let people, let entry) where people.isEmpty:
            ContentUnavailableView.search(text: entry)
        case .loadedPeople(let people, _):
            ScrollView {
                LazyVStack(spacing: Constants.rowSpacing) {
                    ForEach(people) { person in
                        NavigationLink {
                            PersonDetailView(person: person)
                        } label: {
                            PersonRow(person: person)
                        }
                        .buttonStyle(NeumorphicButtonStyle())
                    }
                }
                .padding()
            }
        }
    }
}

private struct SearchQuery: Equatable {
    let entry: String
    let scope: SearchViewModel.SearchScope
}

#Preview {
    SearchView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
