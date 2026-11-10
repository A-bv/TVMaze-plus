//
//  ShowCarousel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftUI

struct ShowCarousel<Item: Identifiable, Destination: View>: View {
    private enum Constants {
        static var height: CGFloat { 200 }
        static var horizontalBleed: CGFloat { -16 }
        static var textSpacing: CGFloat { 2 }
        static var shadeOpacity: Double { 0.8 }
        static var style: ParallaxCarouselStyle {
            ParallaxCarouselStyle(cardWidthInset: 90, cornerRadius: 24, parallaxDistance: 50)
        }
    }

    let items: [Item]
    let show: (Item) -> ShowItemModel
    let caption: (Item) -> String
    @ViewBuilder let destination: (Item) -> Destination

    var body: some View {
        ParallaxCarousel(items, style: Constants.style) { item in
            PosterView(url: show(item).largePosterURL)
        } overlay: { item in
            NavigationLink {
                destination(item)
            } label: {
                VStack(alignment: .leading, spacing: Constants.textSpacing) {
                    Text(show(item).name)
                        .font(.headline)
                    Text(caption(item))
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
