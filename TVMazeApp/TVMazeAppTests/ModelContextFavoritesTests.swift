//
//  ModelContextFavoritesTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import SwiftData
import Testing
@testable import TVMazeApp

@MainActor
struct ModelContextFavoritesTests {
    @Test func toggleFavorite_whenNotSaved_savesTheShow() throws {
        let show = try makeShow()
        let container = try makeContainer()
        let context = container.mainContext

        context.toggleFavorite(show, saved: nil)
        try context.save()

        #expect(try context.fetch(FetchDescriptor<SavedShowModel>()).map(\.showItem) == [show])
    }

    @Test func toggleFavorite_whenSaved_removesTheShow() throws {
        let show = try makeShow()
        let container = try makeContainer()
        let context = container.mainContext
        let saved = SavedShowModel(from: show)
        context.insert(saved)
        try context.save()

        context.toggleFavorite(show, saved: saved)
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<SavedShowModel>()) == 0)
    }
}

extension ModelContextFavoritesTests {
    private func makeShow() throws -> ShowItemModel {
        try #require(FakeShowSearchData.makeShows().first.map { ShowTransformer().transform($0.show) })
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(for: SavedShowModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
}
