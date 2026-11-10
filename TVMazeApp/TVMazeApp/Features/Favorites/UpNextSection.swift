//
//  UpNextSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftUI

struct UpNextSection: View {
    private enum Constants {
        static let title = String(localized: "Up next")
        static let height: CGFloat = 200
        static let horizontalBleed: CGFloat = -16
        static let textSpacing: CGFloat = 3
        static let shadeOpacity = 0.85
        static let style = ParallaxCarouselStyle(cardWidthInset: 90, cornerRadius: 24, parallaxDistance: 50)
    }

    let upNext: [UpNextItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            ParallaxCarousel(upNext, style: Constants.style) { item in
                PosterView(url: item.backgroundURL)
            } overlay: { item in
                NavigationLink {
                    EpisodeDetailView(episode: item.episode, show: item.show)
                } label: {
                    card(for: item)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
            .frame(height: Constants.height)
            .padding(.horizontal, Constants.horizontalBleed)
        }
    }

    private func card(for item: UpNextItemModel) -> some View {
        VStack(alignment: .leading) {
            GlassChip(text: item.airDate.formatted(.dateTime.weekday().day().month().hour().minute()))
                .foregroundStyle(.white)
            Spacer()
            VStack(alignment: .leading, spacing: Constants.textSpacing) {
                Text(item.show.name)
                    .font(.title3.weight(.bold))
                Text(verbatim: item.episode.label)
                    .font(.footnote.weight(.medium))
                    .opacity(Constants.shadeOpacity)
                    .lineLimit(1)
            }
            .foregroundStyle(.white)
        }
        .multilineTextAlignment(.leading)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background {
            LinearGradient(
                colors: [.clear, .black.opacity(Constants.shadeOpacity)],
                startPoint: .center,
                endPoint: .bottom)
        }
        .contentShape(.rect)
    }
}
