//
//  GallerySection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftUI

struct GallerySection: View {
    private enum Constants {
        static let title = String(localized: "Gallery")
        static let height: CGFloat = 210
        static let horizontalBleed: CGFloat = -16
    }

    let gallery: [GalleryItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            ParallaxCarousel(gallery) { item in
                PosterView(url: item.url)
            }
            .frame(height: Constants.height)
            .padding(.horizontal, Constants.horizontalBleed)
        }
    }
}
