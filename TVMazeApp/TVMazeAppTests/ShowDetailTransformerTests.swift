//
//  ShowDetailTransformerTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct ShowDetailTransformerTests {
    @Test func transformer_withRealShow_transformsToExpectedData() throws {
        let sut = makeSut()
        let model = try Fixtures.decode(ShowDetailModel.self, named: "show_detail_response")

        let detail = sut.transform(model)

        #expect(detail.runtime == 49)
        #expect(detail.episodeCount == 19)
        #expect(detail.seasons.map(\.number) == [1, 2, 3])
        #expect(detail.seasons.map(\.episodes.count) == [9, 10, 0])
        #expect(detail.cast.first?.person.name == "Adam Scott")
        #expect(detail.cast.first?.role == "Mark Scout")
        #expect(detail.crew.count == 62)
        #expect(detail.crew.first { $0.person.name == "Adam Scott" }?.role == "Executive Producer · Producer")
        #expect(detail.gallery.count == 5)
        #expect(detail.akas.first == AkaItemModel(name: "Разделение", country: "Russian Federation"))
    }
}

extension ShowDetailTransformerTests {
    private func makeSut() -> ShowDetailTransformer {
        ShowDetailTransformer()
    }
}
