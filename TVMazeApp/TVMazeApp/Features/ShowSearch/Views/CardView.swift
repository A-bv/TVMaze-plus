//
//  CardView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 06.10.2026.
//

import SwiftUI

struct CardView: View {
    private enum Constants {
        static let posterWidth: CGFloat = 210
        static let posterHeight: CGFloat = 295
        static let ratingIcon = "star.fill"
        static let cornerRadius: CGFloat = 16
    }
    
    let show: ShowItemModel
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                PosterView(url: show.posterURL)
                    .frame(width: Constants.posterWidth, height: Constants.posterHeight)
                    .clipShape(.rect(cornerRadius: Constants.cornerRadius))
                
                FavoriteButton(show: show)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .padding()
            }
            
            Text(show.name).font(.headline)
            Text("\(show.years) • \(show.status)").foregroundStyle(.secondary)
            Label(show.rating, systemImage: Constants.ratingIcon)
                .glassEffect()
        }
        .frame(width: Constants.posterWidth)
    }
}
