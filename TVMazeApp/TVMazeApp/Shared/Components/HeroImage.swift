//
//  HeroImage.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct HeroImage: View {
    static let height: CGFloat = 460

    private enum Constants {
        static let shadeOpacity = 0.8
        static let placeholderIcon = "tv"
    }

    let url: URL?
    var placeholderIcon = Constants.placeholderIcon

    var body: some View {
        PosterView(url: url, placeholderIcon: placeholderIcon)
            .overlay {
                LinearGradient(
                    colors: [.clear, .black.opacity(Constants.shadeOpacity)],
                    startPoint: .center,
                    endPoint: .bottom)
            }
    }
}
