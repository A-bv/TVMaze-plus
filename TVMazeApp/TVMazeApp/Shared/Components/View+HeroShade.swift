//
//  View+HeroShade.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

private enum HeroShadeConstants {
    static let topPadding: CGFloat = 120
    static let opacity = 0.6
}

extension View {
    func heroShade() -> some View {
        let shade = Color.black.opacity(HeroShadeConstants.opacity)
        return frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, HeroShadeConstants.topPadding)
            .background {
                LinearGradient(colors: [.clear, shade, shade, shade], startPoint: .top, endPoint: .bottom)
            }
    }
}
