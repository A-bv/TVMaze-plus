//
//  FakeShowSearchData.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

@testable import TVMazeApp

enum FakeShowSearchData {
    static func makeShows(withNilValues: Bool = false, isUpcoming: Bool = false) -> [ShowSearchModel] {
        let show = Show(
                id: 0,
                url: "www.maze-url.com",
                name: "valid name",
                type: "type",
                language: isUpcoming ? nil : "language",
                genres: ["genres"],
                status: "status",
                premiered: isUpcoming ? nil : "2021-09-17",
                ended: withNilValues ? nil : "2022-09-17",
                officialSite: withNilValues ? nil : "https://www.site.com",
                rating: Rating(average: withNilValues ? nil : 5.4),
                image: isUpcoming ? nil : ShowImage(medium: "medium", original: "original"),
                summary: withNilValues ? nil : "<p>Text <b>test.</b></p>",
                updated: 1790843609)
            
            return [ShowSearchModel(show: show)]
    }
}
