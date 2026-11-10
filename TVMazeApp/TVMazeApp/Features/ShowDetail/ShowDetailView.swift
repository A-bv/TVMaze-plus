//
//  ShowDetailView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import ParallaxKit
import SwiftData
import SwiftUI

struct ShowDetailView: View {
    private enum Constants {
        static let headerHeight: CGFloat = 520
        static let sectionSpacing: CGFloat = 32
        static let separator = " · "
        static let castTitle = String(localized: "Cast")
    }

    let show: ShowItemModel

    @State private var viewModel = ShowDetailViewModel()

    var body: some View {
        StretchyHeaderScrollView(headerHeight: Constants.headerHeight, cardColor: .surface) {
            HeroImage(url: show.largePosterURL)
        } headerOverlay: { scrollOffset in
            StretchyHeaderTitle(title: show.name, subtitle: subtitle, scrollOffset: scrollOffset)
        } content: {
            VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                ShowOverviewSection(show: show, detail: detail)
                sections
                AttributionFooter()
            }
            .padding([.horizontal, .bottom])
        }
        .background(.surface)
        .heroNavigationBar(title: show.name, headerHeight: Constants.headerHeight)
        .task {
            await viewModel.loadDetail(showID: show.id)
        }
    }

    @ViewBuilder
    private var sections: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed:
            LoadingErrorView {
                await viewModel.loadDetail(showID: show.id)
            }
        case .loaded(let detail):
            if !detail.seasons.isEmpty {
                EpisodesSection(
                    seasons: detail.seasons,
                    selectedSeason: $viewModel.selectedSeason,
                    episodes: viewModel.selectedEpisodes,
                    showName: show.name,
                    fallbackImageURL: show.largePosterURL)
            }
            if !detail.cast.isEmpty {
                CreditsCarousel(title: Constants.castTitle, credits: detail.cast)
            }
            if !detail.gallery.isEmpty {
                GallerySection(gallery: detail.gallery)
            }
            if !detail.crew.isEmpty {
                CrewSection(crew: detail.crew)
            }
            if !detail.akas.isEmpty {
                AkasSection(akas: detail.akas)
            }
        }
    }

    private var detail: ShowDetailItemModel? {
        guard case .loaded(let detail) = viewModel.state else { return nil }
        return detail
    }

    private var subtitle: String {
        [show.years, show.status, show.channel]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}

#Preview {
    NavigationStack {
        ShowDetailView(
            show: ShowItemModel(
                id: 169,
                name: "Breaking Bad",
                posterURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/501/1253519.jpg"),
                years: "2008 – 2019",
                status: "Ended",
                channel: "AMC",
                genres: "Drama, Crime, Thriller",
                rating: "9.2",
                largePosterURL: URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/501/1253519.jpg"),
                summary: "Breaking Bad follows protagonist Walter White, a chemistry teacher who lives in New Mexico with his wife and teenage son who has cerebral palsy. White is diagnosed with Stage III cancer and given a prognosis of two years left to live. With a new sense of fearlessness based on his medical prognosis, and a desire to secure his family's financial security, White chooses to enter a dangerous world of drugs and crime and ascends to power in this world.",
                type: "Scripted",
                language: "English",
                websiteURL: URL(string: "http://www.amc.com/shows/breaking-bad"),
                lastUpdated: Date(timeIntervalSince1970: 1769198028)))
    }
    .modelContainer(for: SavedShowModel.self, inMemory: true)
}
