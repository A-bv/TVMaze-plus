//
//  TonightHero.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct TonightHero: View {
    private enum Constants {
        static let ratingIcon = "star.fill"
        static let spacing: CGFloat = 8
        static let chipTopPadding: CGFloat = 6
        static let eyebrowKerning: CGFloat = 1.5
        static let eyebrowOpacity = 0.85
        static let horizontalPadding: CGFloat = 36
        static let bottomPadding: CGFloat = 76
        static let fadeOutDistance: CGFloat = 100
    }

    let pick: ScheduleItemModel
    let eyebrow: String
    let timeZone: TimeZone
    let timeZoneName: String?
    let scrollOffset: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(eyebrow)
                .font(.caption.weight(.bold))
                .textCase(.uppercase)
                .kerning(Constants.eyebrowKerning)
                .opacity(Constants.eyebrowOpacity)
            Text(pick.show.name)
                .font(.largeTitle.weight(.bold))
            Text(verbatim: pick.episode.label)
                .font(.subheadline)
            chips
                .padding(.top, Constants.chipTopPadding)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.bottom, Constants.bottomPadding)
        .heroShade()
        .contentShape(.rect)
        .opacity(max(0, min(1, 1 - abs(scrollOffset) / Constants.fadeOutDistance)))
        .accessibilityElement(children: .combine)
    }

    private var chips: some View {
        HStack(spacing: Constants.spacing) {
            if let rating = pick.show.rating {
                GlassChip(text: rating, icon: Constants.ratingIcon)
            }
            if let channel = pick.show.channel {
                GlassChip(text: channel)
            }
            if let timeZoneName, let airDate = pick.episode.airDate {
                GlassChip(text: "\(airDate.formatted(Date.FormatStyle(timeZone: timeZone).hour().minute())) \(timeZoneName)")
            }
        }
    }
}
