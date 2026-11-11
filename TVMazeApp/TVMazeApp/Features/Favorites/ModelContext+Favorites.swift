//
//  ModelContext+Favorites.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import SwiftData

extension ModelContext {
    func toggleFavorite(_ show: ShowItemModel, saved: SavedShowModel?) {
        if let saved {
            delete(saved)
        } else {
            insert(SavedShowModel(from: show))
        }
    }
}
