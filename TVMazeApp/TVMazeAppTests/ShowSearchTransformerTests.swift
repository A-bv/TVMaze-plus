//
//  ShowSearchTransformerTests.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

import Testing
@testable import TVMazeApp
import Foundation

@MainActor
struct ShowSearchTransformerTests {
    @Test func transformer_withInitialData_transformsToExpecedData() {
        let sut = makeSut()
        let shows = FakeShowSearchData.makeShows()
        let transformedShows = sut.transform(shows)
        
        #expect(transformedShows.count == 1)
        #expect(transformedShows.first?.name == "valid name")
        #expect(transformedShows.first?.years == "2021 – 2022")
        #expect(transformedShows.first?.rating == "5.4")
        #expect(transformedShows.first?.summary == "Text test.")
        #expect(transformedShows.first?.websiteURL == URL(string: "https://www.site.com"))
        #expect(transformedShows.first?.lastUpdated == Date(timeIntervalSince1970: 1790843609))
    }
    
    @Test func transformer_withNilData_transformsToExpecedData() {
        let sut = makeSut()
        let shows = FakeShowSearchData.makeShows(withNilValues: true)
        let transformedShows = sut.transform(shows)
        
        #expect(transformedShows.first?.years == "2021 – ")
        #expect(transformedShows.first?.rating == String(localized: "N/A"))
        #expect(transformedShows.first?.summary == String(localized: "No summary available."))
        #expect(transformedShows.first?.websiteURL == URL(string: "www.maze-url.com"))
    }
}

extension ShowSearchTransformerTests {
    func makeSut() -> ShowSearchTransformer {
        ShowSearchTransformer()
    }
}
