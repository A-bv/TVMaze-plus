//
//  ShowTransformerTests.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

import Testing
@testable import TVMazeApp
import Foundation

@MainActor
struct ShowTransformerTests {
    @Test func transformer_withInitialData_transformsToExpectedData() throws {
        let sut = makeSut()
        let transformedShow = sut.transform(try makeShow())
        
        #expect(transformedShow.name == "valid name")
        #expect(transformedShow.years == "2021 – 2022")
        #expect(transformedShow.rating == "5.4")
        #expect(transformedShow.channel == "channel")
        #expect(transformedShow.summary == "Text test.")
        #expect(transformedShow.websiteURL == URL(string: "https://www.site.com"))
        #expect(transformedShow.lastUpdated == Date(timeIntervalSince1970: 1790843609))
    }
    
    @Test func transformer_withNilData_transformsToExpectedData() throws {
        let sut = makeSut()
        let transformedShow = sut.transform(try makeShow(withNilValues: true))
        
        #expect(transformedShow.years == "2021")
        #expect(transformedShow.rating == String(localized: "N/A"))
        #expect(transformedShow.channel == nil)
        #expect(transformedShow.summary == String(localized: "No summary available."))
        #expect(transformedShow.websiteURL == URL(string: "www.maze-url.com"))
    }

    @Test func transformer_withUpcomingShow_usesDefaults() throws {
        let sut = makeSut()
        let transformedShow = sut.transform(try makeShow(isUpcoming: true))

        #expect(transformedShow.years == String(localized: "Upcoming"))
        #expect(transformedShow.posterURL == nil)
        #expect(transformedShow.largePosterURL == nil)
        #expect(transformedShow.language == "")
    }
}

extension ShowTransformerTests {
    private func makeSut() -> ShowTransformer {
        ShowTransformer()
    }

    private func makeShow(withNilValues: Bool = false, isUpcoming: Bool = false) throws -> Show {
        try #require(FakeShowSearchData.makeShows(withNilValues: withNilValues, isUpcoming: isUpcoming).first).show
    }
}
