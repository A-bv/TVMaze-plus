//
//  TonightView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftData
import SwiftUI

struct TonightView: View {
    private enum Constants {
        static let title = String(localized: "Guide")
        static let streamingTitle = String(localized: "New on streaming")
        static let settingsTitle = String(localized: "Settings")
        static let settingsIcon = "gearshape"
        static let sectionSpacing: CGFloat = 32
        static let contentTopPadding: CGFloat = 24
        static let separator = " · "
    }

    @State private var viewModel = TonightViewModel()
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            StretchyHeaderScrollView(
                headerHeight: HeroImage.height,
                cardColor: .surface,
                contentTopPadding: Constants.contentTopPadding
            ) {
                HeroImage(url: pick?.show.largePosterURL)
            } headerOverlay: { scrollOffset in
                header(scrollOffset: scrollOffset)
            } content: {
                VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                    DayStrip(days: viewModel.days, selectedDay: $viewModel.selectedDay)
                    sections
                    AttributionFooter()
                }
                .padding([.horizontal, .bottom])
            }
            .background(.surface)
            .heroNavigationBar(title: Constants.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(Constants.settingsTitle, systemImage: Constants.settingsIcon) {
                        isShowingSettings = true
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass(.clear))
                    .buttonBorderShape(.circle)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView(regions: viewModel.regions, countryCode: $viewModel.countryCode)
            }
            .task(id: viewModel.request) {
                await viewModel.loadSchedule()
            }
        }
    }

    @ViewBuilder
    private func header(scrollOffset: CGFloat) -> some View {
        if case .loaded(let tonight) = viewModel.state, let pick = tonight.pick {
            NavigationLink {
                EpisodeDetailView(episode: pick.episode, show: pick.show)
            } label: {
                TonightHero(
                    pick: pick,
                    eyebrow: viewModel.pickTitle,
                    timeZone: tonight.timeZone,
                    timeZoneName: tonight.isPickOnTV ? tonight.timeZoneName : nil,
                    scrollOffset: scrollOffset)
            }
            .buttonStyle(.plain)
        } else {
            StretchyHeaderTitle(title: Constants.title, scrollOffset: scrollOffset)
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
                await viewModel.loadSchedule()
            }
        case .loaded(let tonight):
            if !tonight.streaming.isEmpty {
                DetailSection(title: Constants.streamingTitle) {
                    ShowCarousel(items: tonight.streaming, show: \.show, caption: caption) { entry in
                        EpisodeDetailView(episode: entry.episode, show: entry.show)
                    }
                }
            }
            TimelineSection(
                title: viewModel.timelineTitle,
                regionName: viewModel.region.name,
                timeZone: tonight.timeZone,
                timeZoneName: tonight.timeZoneName,
                timeSlots: tonight.timeSlots)
        }
    }

    private var pick: ScheduleItemModel? {
        guard case .loaded(let tonight) = viewModel.state else { return nil }
        return tonight.pick
    }

    private func caption(for entry: ScheduleItemModel) -> String {
        [entry.show.channel, entry.episode.code]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}

#Preview {
    TonightView()
        .modelContainer(for: SavedShowModel.self, inMemory: true)
}
