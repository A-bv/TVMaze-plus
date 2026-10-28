//
//  FavoriteButtonView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftData
import SwiftUI

struct FavoriteButton: View {
    let show: ShowItemModel
    
    private enum Constants {
        static let buttonSize: CGFloat = 40
        static let backgroudPoacity: CGFloat = 0.3
    }

    @Environment(\.modelContext) private var context
    @Query private var favorites: [SavedShowModel]

    var body: some View {
        let saved = favorites.first(where: { $0.id == show.id })

        Button {
            if let saved {
                context.delete(saved)
            } else {
                context.insert(SavedShowModel(from: show))
            }
        } label: {
            Image(systemName: saved == nil ? "heart" : "heart.fill")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                    .background(.white.opacity(Constants.backgroudPoacity), in: Circle())
        }
    }
}
