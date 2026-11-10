//
//  PersonMedallion.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct PersonMedallion: View {
    private enum Constants {
        static let imageSize: CGFloat = 80
        static let width: CGFloat = 96
        static let spacing: CGFloat = 6
        static let lineLimit = 2
        static let placeholderIcon = "person.fill"
    }

    let credit: CreditItemModel

    var body: some View {
        VStack(spacing: Constants.spacing) {
            PosterView(url: credit.person.imageURL, placeholderIcon: Constants.placeholderIcon)
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .clipShape(.circle)
                .background {
                    Circle()
                        .fill(.surface)
                        .neumorphicShadow()
                }
            Text(credit.person.name)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.primary)
            Text(credit.role)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .lineLimit(Constants.lineLimit)
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: Constants.width, alignment: .top)
    }
}
