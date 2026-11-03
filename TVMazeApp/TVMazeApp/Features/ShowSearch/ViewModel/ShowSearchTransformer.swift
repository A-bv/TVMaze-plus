//
//  ShowSearchTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 05.10.2026.
//

import Foundation

struct ShowSearchTransformer {
    private enum Constants {
        static let noSummaryMessage = "No summary available."
        static let noRatingMessage = "N/A"
        static let unknownYear = "Upcoming"
    }
    
    func transform(_ models: [ShowSearchModel]) -> [ShowItemModel] {
        var items: [ShowItemModel] = []
        
        for model in models {
            let show = model.show
            
            let item = ShowItemModel(
                id: show.id,
                name: show.name,
                posterURL: makeURL(string: show.image?.medium),
                years: buildTimeRange(start: show.premiered, end: show.ended),
                status: show.status,
                genres: show.genres.joined(separator: ", "),
                rating: formatRating(rating: show.rating.average),
                largePosterURL: makeURL(string: show.image?.original),
                summary: cleanSummary(htmlSummary: show.summary),
                type: show.type,
                language: show.language ?? "",
                websiteURL: URL(string: show.officialSite ?? show.url),
                lastUpdated: Date(timeIntervalSince1970: TimeInterval(show.updated)))
            
            items.append(item)
        }
        
        return items
    }
    
    private func buildTimeRange(start: String?, end: String?) -> String {
        guard let startYear = start?.split(separator: "-").first else {
            return Constants.unknownYear
        }
        let endYear = end?.split(separator: "-").first ?? ""
        return "\(startYear) – \(endYear)"
    }
    
    private func makeURL(string: String?) -> URL? {
        guard let string else { return nil }
        return URL(string: string)
    }
    
    private func formatRating(rating: Double?) -> String {
        guard let rating else {
            return Constants.noRatingMessage
        }
        return String(format: "%.1f", rating)
    }
    
    private func cleanSummary(htmlSummary: String?) -> String {
        guard let htmlSummary else {
            return Constants.noSummaryMessage
        }
        return htmlSummary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
