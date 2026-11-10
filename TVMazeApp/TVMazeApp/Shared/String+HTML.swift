//
//  String+HTML.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

extension String {
    private static let htmlEntities = [
        ("&quot;", "\""),
        ("&#39;", "'"),
        ("&nbsp;", " "),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&amp;", "&")
    ]

    func strippingHTML() -> String {
        Self.htmlEntities.reduce(replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)) { text, entity in
            text.replacingOccurrences(of: entity.0, with: entity.1)
        }
    }
}
