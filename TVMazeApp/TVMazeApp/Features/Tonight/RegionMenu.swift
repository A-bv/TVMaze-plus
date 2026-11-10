//
//  RegionMenu.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct RegionMenu: View {
    private enum Constants {
        static let title = String(localized: "Region")
        static let chevronIcon = "chevron.up.chevron.down"
        static let spacing: CGFloat = 8
        static let flagSize: CGFloat = 22
        static let flagFontSize: CGFloat = 40
        static let flagStrokeOpacity = 0.15
    }

    let region: RegionItemModel
    let regions: [RegionItemModel]
    @Binding var countryCode: String

    var body: some View {
        Menu {
            Picker(Constants.title, selection: $countryCode) {
                ForEach(regions) { region in
                    Text(verbatim: "\(region.flag) \(region.name)")
                        .tag(region.code)
                }
            }
        } label: {
            HStack(spacing: Constants.spacing) {
                flag
                Text(region.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.primary)
                Image(systemName: Constants.chevronIcon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondaryText)
            }
        }
        .buttonStyle(NeumorphicButtonStyle())
        .accessibilityLabel("\(Constants.title) \(region.name)")
    }

    private var flag: some View {
        Text(verbatim: region.flag)
            .font(.system(size: Constants.flagFontSize))
            .frame(width: Constants.flagSize, height: Constants.flagSize)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .stroke(.primary.opacity(Constants.flagStrokeOpacity))
            }
            .accessibilityHidden(true)
    }
}
