//
//  FakeShowSearchData.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

@testable import TVMazeApp

enum FakeShowSearchData {
    static func makeShows(withNilValues: Bool = false) -> [ShowSearchModel] {
        let show = Show(
                id: 0,
                url: "www.maze-url.com",
                name: "valid name",
                type: "type",
                language: "language",
                genres: ["genres"],
                status: "status",
                runtime: nil,
                averageRuntime: withNilValues ? nil : 0,
                premiered: "2021-09-17",
                ended: withNilValues ? nil : "2022-09-17",
                officialSite: withNilValues ? nil : "https://www.site.com",
                schedule: Schedule(time: "time", days: ["days"]),
                rating: Rating(average: withNilValues ? nil : 5.4),
                weight: 0,
                network: nil,
                webChannel: nil,
                dvdCountry: nil,
                externals: Externals(tvrage: nil, thetvdb: nil, imdb: "imdb"),
                image: ShowImage(medium: "medium", original: "original"),
                summary: withNilValues ? nil : "<p>Text <b>test.</b></p>",
                updated: 1790843609,
                links: Links(
                    selfLink: SelfLink(href: "href"),
                    previousEpisode: PreviousEpisode(href: "href", name: "episodeName")))
            
            return [ShowSearchModel(score: 0, show: show)]
    }
}
