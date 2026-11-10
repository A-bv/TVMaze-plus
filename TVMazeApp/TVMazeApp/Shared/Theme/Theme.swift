//
//  Theme.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

extension View {
    func softCinemaTheme() -> some View {
        neumorphicTheme(.softCinema, metrics: .softCinema)
    }
}

private extension NeumorphicPalette {
    static let softCinema = NeumorphicPalette(
        gradientStart: Color(.surfaceGradientStart),
        gradientEnd: Color(.surfaceGradientEnd),
        lowerShadow: Color(.surfaceShadow),
        upperShadow: Color(.surfaceHighlight),
        highlightStroke: .accentColor,
        baseStroke: Color(.surfaceGradientEnd),
        background: Color(.surface))
}

private extension NeumorphicMetrics {
    static let softCinema = NeumorphicMetrics(cornerRadius: 18, shadowRadius: 6, strokeWidth: 2, depth: 6)
}
