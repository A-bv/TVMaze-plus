//
//  PersonDetailView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import ParallaxKit
import SwiftData
import SwiftUI

struct PersonDetailView: View {
    private enum Constants {
        static let sectionSpacing: CGFloat = 32
        static let tileSpacing: CGFloat = 14
        static let placeholderIcon = "person.fill"
        static let ageTitle = String(localized: "Age")
        static let showsTitle = String(localized: "Shows")
        static let guestRolesTitle = String(localized: "Guest roles")
        static let missingValue = "–"
    }

    let person: PersonItemModel

    @State private var viewModel = PersonDetailViewModel()

    var body: some View {
        StretchyHeaderScrollView(headerHeight: HeroImage.height, cardColor: .surface) {
            HeroImage(url: person.largeImageURL, placeholderIcon: Constants.placeholderIcon)
        } headerOverlay: { scrollOffset in
            StretchyHeaderTitle(title: person.name, subtitle: viewModel.subtitle(of: person), scrollOffset: scrollOffset)
                .heroShade()
        } content: {
            VStack(alignment: .leading, spacing: Constants.sectionSpacing) {
                tiles
                sections
                AttributionFooter()
            }
            .padding([.horizontal, .bottom])
        }
        .background(.surface)
        .heroNavigationBar(title: person.name)
        .task {
            await viewModel.loadDetail(personID: person.id)
        }
    }

    private var tiles: some View {
        HStack(spacing: Constants.tileSpacing) {
            if let age = viewModel.age(of: person) {
                StatTile(title: Constants.ageTitle, value: String(age))
            }
            StatTile(
                title: Constants.showsTitle,
                value: viewModel.detail.map { String($0.showCount) } ?? Constants.missingValue)
            StatTile(
                title: Constants.guestRolesTitle,
                value: viewModel.detail.map { String($0.guestAppearances.count) } ?? Constants.missingValue)
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
                await viewModel.loadDetail(personID: person.id)
            }
        case .loaded(let detail):
            if !detail.knownFor.isEmpty {
                KnownForSection(credits: detail.knownFor)
            }
            if !detail.behindTheCamera.isEmpty {
                BehindTheCameraSection(credits: detail.behindTheCamera)
            }
            if !detail.guestAppearances.isEmpty {
                GuestAppearancesSection(appearances: detail.guestAppearances)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonDetailView(
            person: PersonItemModel(
                id: 31964,
                name: "Adam Scott",
                imageURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/3/8618.jpg"),
                largeImageURL: URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/3/8618.jpg"),
                birthday: Date(timeIntervalSince1970: 102_643_200),
                deathday: nil,
                country: "United States"))
    }
    .modelContainer(for: SavedShowModel.self, inMemory: true)
}
