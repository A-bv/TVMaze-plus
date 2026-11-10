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
    private enum Constants {
        static let memoryCapacity = 20 * 1024 * 1024
        static let diskCapacity = 200 * 1024 * 1024
    }

    init() {
        URLCache.shared = URLCache(memoryCapacity: Constants.memoryCapacity, diskCapacity: Constants.diskCapacity)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .softCinemaTheme()
        }
        .modelContainer(for: SavedShowModel.self)
    }
}
