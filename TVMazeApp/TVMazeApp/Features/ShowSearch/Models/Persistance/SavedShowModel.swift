//
//  SavedShowModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import Foundation
import SwiftData

@Model
final class SavedShowModel {
    @Attribute(.unique) var id: Int
    var name: String
    var posterURL: URL?
    var years: String
    var status: String
    var genres: String
    var rating: String
    var largePosterURL: URL?
    var summary: String
    var type: String
    var language: String?
    var websiteURL: URL?
    var lastUpdated: Date
    var savedAt: Date = Date.now
    
    init(from show: ShowItemModel) {
        id = show.id
        name = show.name
        posterURL = show.posterURL
        years = show.years
        status = show.status
        genres = show.genres
        rating = show.rating
        largePosterURL = show.largePosterURL
        summary = show.summary
        type = show.type
        language = show.language
        websiteURL = show.websiteURL
        lastUpdated = show.lastUpdated
    }

    var showItem: ShowItemModel {
        ShowItemModel(
            id: id,
            name: name,
            posterURL: posterURL,
            years: years,
            status: status,
            genres: genres,
            rating: rating,
            largePosterURL: largePosterURL,
            summary: summary,
            type: type,
            language: language ?? "",
            websiteURL: websiteURL,
            lastUpdated: lastUpdated)
    }
}
