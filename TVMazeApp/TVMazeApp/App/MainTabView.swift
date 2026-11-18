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

    @Environment(\.tvMazeService) private var service

    init() {
        UINavigationBar.applySoftCinemaTitles()
    }

    var body: some View {
        TabView {
            Tab(Constants.tonightTitle, systemImage: Constants.tonightIcon) {
                TonightView(service: service)
            }
            Tab(Constants.favoritesTitle, systemImage: Constants.favoritesIcon) {
                FavoritesView(service: service)
            }
            Tab(Constants.searchTitle, systemImage: Constants.searchIcon, role: .search) {
                SearchView(service: service)
            }
        }
    }
}
