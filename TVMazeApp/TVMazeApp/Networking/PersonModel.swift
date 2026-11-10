//
//  PersonModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

struct Person: Decodable, Equatable {
    let id: Int
    let name: String
    let country: Country?
    let birthday: String?
    let deathday: String?
    let image: ImageLinks?
}
