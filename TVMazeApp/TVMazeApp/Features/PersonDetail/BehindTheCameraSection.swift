//
//  BehindTheCameraSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct BehindTheCameraSection: View {
    private enum Constants {
        static let title = String(localized: "Behind the camera")
    }

    let credits: [ShowCreditItemModel]

    var body: some View {
        DetailSection(title: Constants.title) {
            VStack(spacing: 0) {
                ForEach(credits) { credit in
                    NavigationLink {
                        ShowDetailView(show: credit.show)
                    } label: {
                        CreditRow(name: credit.show.name, role: credit.role)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
