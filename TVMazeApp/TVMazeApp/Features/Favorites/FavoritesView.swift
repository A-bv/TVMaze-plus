//
//  FavoritesView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    private enum Constants {
        static let title = String(localized: "Favorites")
        static let thumbnailWidth: CGFloat = 50
        static let thumbnailHeight: CGFloat = 75
        static let thumbnailCornerRadius: CGFloat = 8
    }

    @Environment(\.modelContext) private var context
    @Query private var favorites: [SavedShowModel]

    var body: some View {
        NavigationStack {
            List {
                ForEach(favorites) { favorite in
                    NavigationLink {
                        ShowDetailView(show: favorite.showItem)
                    } label: {
                        HStack {
                            PosterView(url: favorite.posterURL)
                                .frame(width: Constants.thumbnailWidth, height: Constants.thumbnailHeight)
                                .clipShape(.rect(cornerRadius: Constants.thumbnailCornerRadius))
                            VStack(alignment: .leading) {
                                Text(favorite.name).font(.headline)
                                Text(favorite.years).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    for index in offsets {
                        context.delete(favorites[index])
                    }
                }
            }
            .navigationTitle(Constants.title)
        }
    }
}
