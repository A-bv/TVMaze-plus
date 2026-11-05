//
//  ShowSearchModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 28.09.2026.
//

struct ShowSearchModel: Decodable, Equatable {
    let show: Show
}

struct Show: Decodable, Equatable {
    let id: Int
    let url: String
    let name: String
    let type: String
    let language: String?
    let genres: [String]
    let status: String
    let premiered: String?
    let ended: String?
    let officialSite: String?
    let rating: Rating
    let image: ShowImage?
    let summary: String?
    let updated: Int
}

struct ShowImage: Decodable, Equatable {
    let medium: String
    let original: String
}

struct Rating: Decodable, Equatable {
    let average: Double?
}
