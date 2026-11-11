//
//  ShowTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

import Foundation

struct ShowTransformer {
    private enum Constants {
        static let noSummaryMessage = String(localized: "No summary available.")
        static let unknownYear = String(localized: "Upcoming")
        static let statuses = [
            "Running": String(localized: "Running"),
            "Ended": String(localized: "Ended"),
            "To Be Determined": String(localized: "To Be Determined"),
            "In Development": String(localized: "In Development")
        ]
    }

    func transform(_ show: Show) -> ShowItemModel {
        ShowItemModel(
            id: show.id,
            name: show.name,
            posterURL: makeURL(string: show.image?.medium),
            years: buildTimeRange(start: show.premiered, end: show.ended),
            status: Constants.statuses[show.status] ?? show.status,
            channel: show.network?.name ?? show.webChannel?.name,
            genres: show.genres.joined(separator: ", "),
            rating: show.rating.average.map { String(format: "%.1f", $0) },
            largePosterURL: makeURL(string: show.image?.original),
            summary: cleanSummary(htmlSummary: show.summary),
            type: show.type,
            language: show.language ?? "",
            websiteURL: URL(string: show.officialSite ?? show.url),
            lastUpdated: Date(timeIntervalSince1970: TimeInterval(show.updated)))
    }

    private func buildTimeRange(start: String?, end: String?) -> String {
        guard let startYear = start?.split(separator: "-").first else {
            return Constants.unknownYear
        }
        guard let endYear = end?.split(separator: "-").first, endYear != startYear else {
            return String(startYear)
        }
        return "\(startYear) – \(endYear)"
    }

    private func makeURL(string: String?) -> URL? {
        guard let string else { return nil }
        return URL(string: string)
    }

    private func cleanSummary(htmlSummary: String?) -> String {
        guard let htmlSummary else {
            return Constants.noSummaryMessage
        }
        return htmlSummary.strippingHTML()
    }
}
