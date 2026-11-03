//
//  ShowSearchDetailView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 07.10.2026.
//

import SwiftUI

struct ShowDetailView: View {
    private enum Constants {
        static let ratingIcon = "star.fill"
        static let websiteTitle = "Website"
        static let updatedTitle = "Last updated:"
        static let cornerRadius: CGFloat = 16
        static let posterAspectRatio: CGFloat = 2 / 3
    }
    
    let show: ShowItemModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PosterView(url: show.largePosterURL)
                    .aspectRatio(Constants.posterAspectRatio, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(Constants.cornerRadius)
                
                HStack {
                    Text(show.name).font(.title.bold())
                    Spacer()
                    Label(show.rating, systemImage: Constants.ratingIcon)
                        .glassEffect()
                    FavoriteButton(show: show)
                        .glassEffect()
                }
                
                Text("\(show.years) • \(show.status)").foregroundStyle(.secondary)
                Text("\(show.type) • \(show.language)").foregroundStyle(.secondary)
                Text(show.genres).foregroundStyle(.secondary)
                Spacer()
                Text(show.summary)
                
                if let url = show.websiteURL {
                    Link(Constants.websiteTitle, destination: url)
                        .buttonStyle(.glassProminent)
                }
                
                Text("\(Constants.updatedTitle) \(show.lastUpdated.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(show.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ShowDetailView(
        show: ShowItemModel(
            id: 169,
            name: "Breaking Bad",
            posterURL: URL(string: "https://static.tvmaze.com/uploads/images/medium_portrait/501/1253519.jpg"),
            years: "2008 – 2019",
            status: "Ended",
            genres: "Drama, Crime, Thriller",
            rating: "9.2",
            largePosterURL: URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/501/1253519.jpg"),
            summary: "Breaking Bad follows protagonist Walter White, a chemistry teacher who lives in New Mexico with his wife and teenage son who has cerebral palsy. White is diagnosed with Stage III cancer and given a prognosis of two years left to live. With a new sense of fearlessness based on his medical prognosis, and a desire to secure his family's financial security, White chooses to enter a dangerous world of drugs and crime and ascends to power in this world.",
            type: "Scripted",
            language: "English",
            websiteURL: URL(string: "http://www.amc.com/shows/breaking-bad"),
            lastUpdated: Date(timeIntervalSince1970: 1769198028)))
}
