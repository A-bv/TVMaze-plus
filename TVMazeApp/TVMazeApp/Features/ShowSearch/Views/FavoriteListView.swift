//
//  FavoriteListView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @Query private var favorites: [SavedShowModel]

    var body: some View {
        NavigationStack{
            List(favorites) { show in
                HStack {
                    Text(show.name)
                    Spacer()
                    Button {
                        context.delete(show)
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
