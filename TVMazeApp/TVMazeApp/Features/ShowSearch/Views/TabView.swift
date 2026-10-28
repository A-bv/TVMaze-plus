//
//  TabView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Search", systemImage: "magnifyingglass") {
                ShowSearchMainView()
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesView()
            }
        }
    }
}
