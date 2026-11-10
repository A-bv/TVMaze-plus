//
//  CastSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct CastSection: View {
    private enum Constants {
        static let title = String(localized: "Cast")
        static let spacing: CGFloat = 14
        static let shadowSpace: CGFloat = 10
    }

    let cast: [CreditItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: Constants.spacing) {
                    ForEach(cast) { credit in
                        PersonMedallion(credit: credit)
                    }
                }
                .padding(.vertical, Constants.shadowSpace)
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
}
