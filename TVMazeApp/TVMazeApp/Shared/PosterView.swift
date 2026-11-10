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
    var placeholderIcon = Constants.placeholderIcon

    @State private var image: UIImage?
    @State private var loadedURL: URL?
    @State private var hasFailed = false

    var body: some View {
        Color.clear
            .overlay {
                if let image, loadedURL == url {
                    Image(uiImage: image).resizable().scaledToFill()
                } else if hasFailed || url == nil {
                    Image(systemName: placeholderIcon)
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.quaternary)
                } else {
                    ProgressView()
                }
            }
            .clipped()
            .accessibilityHidden(true)
            .task(id: url) {
                await loadImage()
            }
    }

    private func loadImage() async {
        guard let url, url != loadedURL else { return }
        hasFailed = false

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            image = await UIImage(data: data)?.byPreparingForDisplay()
            loadedURL = url
            hasFailed = image == nil
        } catch {
            hasFailed = !Task.isCancelled
        }
    }
}
