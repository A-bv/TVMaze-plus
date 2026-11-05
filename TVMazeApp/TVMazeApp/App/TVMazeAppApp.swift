//
//  TVMazeAppApp.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 26.09.2026.
//

import SwiftUI
import SwiftData

@main
struct TVMazeAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: SavedShowModel.self)
    }
}
