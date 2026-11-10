//
//  LoadingErrorView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct LoadingErrorView: View {
    private enum Constants {
        static let title = String(localized: "Something went wrong")
        static let message = String(localized: "Check your connection and try again.")
        static let icon = "exclamationmark.triangle"
        static let retryTitle = String(localized: "Try again")
    }

    let retry: () async -> Void

    var body: some View {
        ContentUnavailableView {
            Label(Constants.title, systemImage: Constants.icon)
        } description: {
            Text(Constants.message)
        } actions: {
            Button(Constants.retryTitle) {
                Task { await retry() }
            }
            .buttonStyle(NeumorphicButtonStyle())
        }
    }
}
