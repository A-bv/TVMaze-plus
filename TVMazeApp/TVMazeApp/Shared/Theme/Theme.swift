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
            .fontDesign(.rounded)
    }
}

extension UINavigationBar {
    static func applySoftCinemaTitles() {
        let bar = appearance()
        bar.largeTitleTextAttributes = [.font: UIFont.rounded(.largeTitle, traits: .traitBold)]
        bar.titleTextAttributes = [.font: UIFont.rounded(.headline)]
    }
}

private extension UIFont {
    static func rounded(_ style: TextStyle, traits: UIFontDescriptor.SymbolicTraits = []) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let styled = descriptor.withSymbolicTraits(traits)?.withDesign(.rounded) ?? descriptor
        return UIFont(descriptor: styled, size: 0)
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
