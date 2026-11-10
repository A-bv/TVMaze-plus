//
//  EpisodeDetailView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftData
import SwiftUI

struct EpisodeDetailView: View {
    private enum Constants {
        static let sectionSpacing: CGFloat = 32
        static let tileSpacing: CGFloat = 14
        static let separator = " · "
        static let ratingTitle = String(localized: "Rating")
        static let ratingIcon = "star.fill"
        static let runtimeTitle = String(localized: "Runtime")
        static let airDateTitle = String(localized: "Air date")
        static let guestCastTitle = String(localized: "Guest cast")
        static let missingValue = "–"
    }

    let showName: String
    let fallbackImageURL: URL?
    let show: ShowItemModel?

    @State private var viewModel: EpisodeDetailViewModel

    init(episode: EpisodeItemModel, episodes: [EpisodeItemModel], showName: String, fallbackImageURL: URL?) {
        self.showName = showName
        self.fallbackImageURL = fallbackImageURL
        show = nil
        _viewModel = State(initialValue: EpisodeDetailViewModel(episode: episode, episodes: episodes))
    }

    init(episode: EpisodeItemModel, show: ShowItemModel) {
        showName = show.name
        fallbackImageURL = show.largePosterURL
        self.show = show
        _viewModel = State(initialValue: EpisodeDetailViewModel(episode: episode, episodes: [episode]))
    }

    var body: some View {
        let episode = viewModel.episode

        StretchyHeaderScrollView(headerHeight: HeroImage.height, cardColor: .surface) {
            HeroImage(url: episode.largeImageURL ?? fallbackImageURL)
        } headerOverlay: { scrollOffset in
            StretchyHeaderTitle(
                title: episode.name,
                subtitle: "\(showName)\(Constants.separator)\(episode.code)",
                scrollOffset: scrollOffset)
            .heroShade()
        } content: {
            VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                tiles
                if let show {
                    ShowLinkRow(show: show)
                }
                if let summary = episode.summary {
                    Text(summary)
                }
                guests
                AroundEpisodeSection(
                    previous: viewModel.previousEpisode,
                    next: viewModel.nextEpisode,
                    fallbackImageURL: fallbackImageURL
                ) { neighbor in
                    viewModel.select(neighbor)
                }
                AttributionFooter()
            }
            .padding([.horizontal, .bottom])
        }
        .id(episode.id)
        .background(.surface)
        .heroNavigationBar(title: episode.name)
        .task(id: episode.id) {
            await viewModel.loadGuests()
        }
    }

    private var tiles: some View {
        let episode = viewModel.episode

        return HStack(spacing: Constants.tileSpacing) {
            StatTile(
                title: Constants.ratingTitle,
                value: episode.rating ?? Constants.missingValue,
                icon: Constants.ratingIcon)
            StatTile(
                title: Constants.runtimeTitle,
                value: episode.runtime?.runtimeText ?? Constants.missingValue)
            StatTile(
                title: Constants.airDateTitle,
                value: episode.airDate?.formatted(.dateTime.day().month(.abbreviated).year()) ?? Constants.missingValue)
        }
    }

    @ViewBuilder
    private var guests: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed:
            LoadingErrorView {
                await viewModel.loadGuests()
            }
        case .loaded(let guests):
            if !guests.cast.isEmpty {
                CreditsCarousel(title: Constants.guestCastTitle, credits: guests.cast)
            }
            if !guests.crew.isEmpty {
                CrewSection(crew: guests.crew)
            }
        }
    }
}

#Preview {
    let episode = EpisodeItemModel(
        id: 2939707,
        name: "Chikhai Bardo",
        season: 2,
        number: 7,
        airDate: Date(timeIntervalSince1970: 1740744000),
        runtime: 50,
        rating: "7.7",
        imageURL: nil,
        largeImageURL: URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/556/1392078.jpg"),
        summary: "An old romance intersects with a deadly present threat.")

    NavigationStack {
        EpisodeDetailView(episode: episode, episodes: [episode], showName: "Severance", fallbackImageURL: nil)
    }
    .modelContainer(for: SavedShowModel.self, inMemory: true)
}
