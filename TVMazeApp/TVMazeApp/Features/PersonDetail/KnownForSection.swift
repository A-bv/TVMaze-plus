//
//  KnownForSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftUI

struct KnownForSection: View {
    private enum Constants {
        static let title = String(localized: "Known for")
        static let height: CGFloat = 340
        static let horizontalBleed: CGFloat = -16
        static let textSpacing: CGFloat = 2
        static let shadeOpacity = 0.8
        static let style = ParallaxCarouselStyle(cardWidthInset: 170, cornerRadius: 20, parallaxDistance: 40)
    }

    let credits: [ShowCreditItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            ParallaxCarousel(credits, style: Constants.style) { credit in
                PosterView(url: credit.show.largePosterURL)
            } overlay: { credit in
                NavigationLink {
                    ShowDetailView(show: credit.show)
                } label: {
                    VStack(alignment: .leading, spacing: Constants.textSpacing) {
                        Text(credit.show.name)
                            .font(.headline)
                        Text(credit.role)
                            .font(.caption)
                            .opacity(Constants.shadeOpacity)
                    }
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .background {
                        LinearGradient(
                            colors: [.clear, .black.opacity(Constants.shadeOpacity)],
                            startPoint: .center,
                            endPoint: .bottom)
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
            .frame(height: Constants.height)
            .padding(.horizontal, Constants.horizontalBleed)
        }
    }
}
