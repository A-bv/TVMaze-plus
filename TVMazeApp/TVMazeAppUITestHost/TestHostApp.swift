//
//  TestHostApp.swift
//  TVMazeAppUITestHost
//
//  Created by Alexandre Bevilacqua on 18.11.2026.
//

import SwiftData
import SwiftUI

@main
struct TestHostApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .softCinemaTheme()
                .environment(\.tvMazeService, TVMazeAPIServiceImpl(session: FakeDataSession()))
        }
        .modelContainer(for: SavedShowModel.self, inMemory: true)
    }
}
