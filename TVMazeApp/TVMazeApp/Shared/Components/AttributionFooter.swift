//
//  AttributionFooter.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct AttributionFooter: View {
    private enum Constants {
        static let title = String(localized: "Data from TVmaze")
        static let url = URL(string: "https://www.tvmaze.com")
    }

    var body: some View {
        if let url = Constants.url {
            Link(Constants.title, destination: url)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        }
    }
}
