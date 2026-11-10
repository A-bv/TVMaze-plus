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

    @Test func transformer_withShowEndingTheYearItStarted_showsOneYear() {
        let sut = makeSut()
        let show = makeShow(status: "Ended", premiered: "2025-01-10", ended: "2025-03-28")

        #expect(sut.transform(show).years == "2025")
    }

    @Test func transformer_withKnownStatus_translatesIt() {
        let sut = makeSut()
        let show = makeShow(status: "Running", premiered: "2025-01-10", ended: nil)

        #expect(sut.transform(show).status == String(localized: "Running"))
    }

    @Test func transformer_withUnknownStatus_keepsIt() throws {
        let sut = makeSut()

        #expect(sut.transform(try makeShow()).status == "status")
    }
}

extension ShowTransformerTests {
    private func makeSut() -> ShowTransformer {
        ShowTransformer()
    }

    private func makeShow(withNilValues: Bool = false, isUpcoming: Bool = false) throws -> Show {
        try #require(FakeShowSearchData.makeShows(withNilValues: withNilValues, isUpcoming: isUpcoming).first).show
    }

    private func makeShow(status: String, premiered: String, ended: String?) -> Show {
        Show(
            id: 0,
            url: "www.maze-url.com",
            name: "name",
            type: "type",
            language: nil,
            genres: [],
            status: status,
            averageRuntime: nil,
            premiered: premiered,
            ended: ended,
            officialSite: nil,
            schedule: ShowSchedule(time: "", days: []),
            rating: Rating(average: nil),
            network: nil,
            webChannel: nil,
            image: nil,
            summary: nil,
            updated: 0)
    }
}
