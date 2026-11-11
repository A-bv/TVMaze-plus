//
//  SavedShowModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 03.11.2026.
//

import Foundation
import SwiftData
import Testing
@testable import TVMazeApp

@MainActor
struct SavedShowModelTests {
    @Test func savedShow_whenConvertedBack_matchesTheOriginalShow() throws {
        let show = try #require(FakeShowSearchData.makeShows().first.map { ShowTransformer().transform($0.show) })
        let savedShow = SavedShowModel(from: show)
        #expect(savedShow.showItem == show)
    }

    @Test func savedShow_whenUpdated_matchesTheNewShow() throws {
        let savedShow = SavedShowModel(from: try makeShow())
        let newShow = try #require(FakeShowSearchData.makeShows(withNilValues: true).first.map { ShowTransformer().transform($0.show) })

        savedShow.update(from: newShow)

        #expect(savedShow.showItem == newShow)
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

    @Test func savedShow_matchesOnlyItsOwnShow() throws {
        let shows = [makeShow(id: 1), makeShow(id: 2)]
        let container = try makeContainer()
        let context = container.mainContext
        shows.forEach { context.insert(SavedShowModel(from: $0)) }
        try context.save()

        let matches = try context.fetch(FetchDescriptor(predicate: SavedShowModel.matching(shows[1])))

        #expect(matches.map(\.id) == [shows[1].id])
    }
}

extension SavedShowModelTests {
    private func makeShow() throws -> ShowItemModel {
        try #require(FakeShowSearchData.makeShows().first.map { ShowTransformer().transform($0.show) })
    }

    private func makeShow(id: Int) -> ShowItemModel {
        ShowItemModel(
            id: id,
            name: "Show \(id)",
            posterURL: nil,
            years: "2020",
            status: "Running",
            channel: nil,
            genres: "",
            rating: nil,
            largePosterURL: nil,
            summary: "",
            type: "Scripted",
            language: "English",
            websiteURL: nil,
            lastUpdated: .now)
    }

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(for: SavedShowModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    }
}
