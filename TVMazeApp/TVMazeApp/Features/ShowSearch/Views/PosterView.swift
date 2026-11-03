//
//  PosterView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 03.11.2026.
//

import SwiftUI

struct PosterView: View {
    private enum Constants {
        static let placeholderIcon = "tv"
    }

    let url: URL?

    var body: some View {
        Color.clear
            .overlay {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFill()
                    } else if phase.error != nil || url == nil {
                        Image(systemName: Constants.placeholderIcon)
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.quaternary)
                    } else {
                        ProgressView()
                    }
                }
            }
            .clipped()
    }
}
