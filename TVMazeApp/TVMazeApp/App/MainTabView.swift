//
//  MainTabView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI

struct MainTabView: View {
    private enum Constants {
        static let searchTitle = String(localized: "Search")
        static let searchIcon = "magnifyingglass"
        static let favoritesTitle = String(localized: "Favorites")
        static let favoritesIcon = "heart"
    }

    var body: some View {
        TabView {
            Tab(Constants.searchTitle, systemImage: Constants.searchIcon) {
                ShowSearchMainView()
            }
            Tab(Constants.favoritesTitle, systemImage: Constants.favoritesIcon) {
                FavoritesView()
            }
        }
    }
}
