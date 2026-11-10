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
        static let title = String(localized: "Tonight")
        static let streamingTitle = String(localized: "New episodes on streaming")
        static let tonightTitle = String(localized: "On TV tonight")
        static let tonightPick = String(localized: "Tonight's pick")
        static let sectionSpacing: CGFloat = 32
        static let separator = " · "
    }

    @State private var viewModel = TonightViewModel()

    var body: some View {
        NavigationStack {
            StretchyHeaderScrollView(headerHeight: HeroImage.height, cardColor: .surface) {
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
            .task(id: viewModel.selectedDay) {
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
                TonightHero(pick: pick, eyebrow: eyebrow, timeZone: tonight.timeZone, scrollOffset: scrollOffset)
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
                title: timelineTitle,
                country: tonight.country,
                timeZone: tonight.timeZone,
                timeSlots: tonight.timeSlots)
        }
    }

    private var pick: ScheduleItemModel? {
        guard case .loaded(let tonight) = viewModel.state else { return nil }
        return tonight.pick
    }

    private var weekday: String {
        viewModel.selectedDay.formatted(.dateTime.weekday(.wide))
    }

    private var timelineTitle: String {
        viewModel.isTonight ? Constants.tonightTitle : String(localized: "On TV \(weekday) evening")
    }

    private var eyebrow: String {
        viewModel.isTonight ? Constants.tonightPick : String(localized: "Pick for \(weekday)")
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
