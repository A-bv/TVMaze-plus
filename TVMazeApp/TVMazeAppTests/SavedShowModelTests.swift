//
//  SavedShowModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 03.11.2026.
//

import SwiftData
import Testing
@testable import TVMazeApp

@MainActor
struct SavedShowModelTests {
    @Test func savedShow_whenConvertedBack_matchesTheOriginalShow() throws {
        let show = try #require(ShowSearchTransformer().transform(FakeShowSearchData.makeShows()).first)
        let savedShow = SavedShowModel(from: show)
        #expect(savedShow.showItem == show)
    }

    @Test func savedShow_whenSaved_comesBackWithItsData() throws {
        let show = try makeShow()
        let container = try makeContainer()
        let context = container.mainContext

        context.insert(SavedShowModel(from: show))
        try context.save()

        let savedShows = try context.fetch(FetchDescriptor<SavedShowModel>())
        #expect(savedShows.map(\.showItem) == [show])
    }

    @Test func savedShow_whenSavedTwice_isNotDuplicated() throws {
        let show = try makeShow()
        let container = try makeContainer()
        let context = container.mainContext

        context.insert(SavedShowModel(from: show))
        try context.save()
        context.insert(SavedShowModel(from: show))
        try context.save()

        #expect(try context.fetchCount(FetchDescriptor<SavedShowModel>()) == 1)
    }
}

extension SavedShowModelTests {
    private func makeShow() throws -> ShowItemModel {
        try #require(ShowSearchTransformer().transform(FakeShowSearchData.makeShows()).first)
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(for: SavedShowModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
}
