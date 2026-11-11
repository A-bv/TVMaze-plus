//
//  MainTabView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI

struct MainTabView: View {
    private enum Constants {
        static let tonightTitle = String(localized: "Guide")
        static let tonightIcon = "tv"
        static let favoritesTitle = String(localized: "Favorites")
        static let favoritesIcon = "heart"
        static let searchTitle = String(localized: "Search")
        static let searchIcon = "magnifyingglass"
    }

    init() {
        UINavigationBar.applySoftCinemaTitles()
    }

    var body: some View {
        TabView {
            Tab(Constants.tonightTitle, systemImage: Constants.tonightIcon) {
                TonightView()
            }
            Tab(Constants.favoritesTitle, systemImage: Constants.favoritesIcon) {
                FavoritesView()
            }
            Tab(Constants.searchTitle, systemImage: Constants.searchIcon, role: .search) {
                SearchView()
            }
        }
    }
}
