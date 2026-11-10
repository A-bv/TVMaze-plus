//
//  GlassChip.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct GlassChip: View {
    private enum Constants {
        static let spacing: CGFloat = 4
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 6
        static let tintOpacity = 0.3
    }

    let text: String
    var icon: String?

    var body: some View {
        HStack(spacing: Constants.spacing) {
            if let icon {
                Image(systemName: icon)
            }
            Text(text)
                .lineLimit(1)
        }
        .font(.caption.weight(.bold))
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .glassEffect(.clear.tint(.black.opacity(Constants.tintOpacity)), in: .capsule)
    }
}
