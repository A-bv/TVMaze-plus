//
//  CreditRow.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct CreditRow: View {
    private enum Constants {
        static let spacing: CGFloat = 12
        static let verticalPadding: CGFloat = 10
    }

    let name: String
    let role: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Constants.spacing) {
            Text(name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Spacer()
            Text(role)
                .font(.subheadline)
                .foregroundStyle(.secondaryText)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, Constants.verticalPadding)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}
