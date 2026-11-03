//
//  SavedShowModelTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 03.11.2026.
//

import Testing
@testable import TVMazeApp

@MainActor
struct SavedShowModelTests {
    @Test func savedShow_whenConvertedBack_matchesTheOriginalShow() throws {
        let show = try #require(ShowSearchTransformer().transform(FakeShowSearchData.makeShows()).first)
        let savedShow = SavedShowModel(from: show)
        #expect(savedShow.showItem == show)
    }
}
