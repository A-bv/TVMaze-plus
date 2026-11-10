//
//  ShowAllButton.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct ShowAllButton: View {
    private enum Constants {
        static let showLessTitle = String(localized: "Show less")
    }

    let count: Int
    @Binding var isExpanded: Bool

    var body: some View {
        Button(isExpanded ? Constants.showLessTitle : String(localized: "Show all \(count)")) {
            isExpanded.toggle()
        }
        .font(.subheadline.weight(.semibold))
        .frame(maxWidth: .infinity)
        .buttonStyle(NeumorphicButtonStyle())
    }
}
