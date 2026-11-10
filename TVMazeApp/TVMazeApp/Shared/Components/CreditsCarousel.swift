//
//  CreditsCarousel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct CreditsCarousel: View {
    private enum Constants {
        static let spacing: CGFloat = 14
        static let shadowSpace: CGFloat = 10
    }

    let title: String
    let credits: [CreditItemModel]

    var body: some View {
        DetailSection(title: title) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: Constants.spacing) {
                    ForEach(credits) { credit in
                        NavigationLink {
                            PersonDetailView(person: credit.person)
                        } label: {
                            PersonMedallion(credit: credit)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, Constants.shadowSpace)
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }
}
