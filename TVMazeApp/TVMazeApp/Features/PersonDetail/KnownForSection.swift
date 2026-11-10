//
//  KnownForSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct KnownForSection: View {
    private enum Constants {
        static let title = String(localized: "Known for")
    }

    let credits: [ShowCreditItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            ShowCarousel(items: credits, show: \.show, caption: \.role)
        }
    }
}
