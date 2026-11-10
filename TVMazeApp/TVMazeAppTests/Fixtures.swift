//
//  Fixtures.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Testing

enum Fixtures {
    private final class BundleToken {}

    static func data(named name: String) throws -> Data {
        let url = try #require(Bundle(for: BundleToken.self).url(forResource: name, withExtension: "json"))
        return try Data(contentsOf: url)
    }

    static func decode<Model: Decodable>(_ type: Model.Type, named name: String) throws -> Model {
        try JSONDecoder().decode(type, from: data(named: name))
    }
}
