//
//  HeroNavigationBar.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct HeroNavigationBar: ViewModifier {
    private enum Constants {
        static let barHeight: CGFloat = 120
    }

    let title: String
    let headerHeight: CGFloat

    @Environment(\.colorScheme) private var colorScheme
    @State private var isPastHeader = false

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.contentOffset.y > headerHeight - Constants.barHeight
            } action: { _, isPast in
                isPastHeader = isPast
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.surface, for: .navigationBar)
            .toolbarBackgroundVisibility(isPastHeader ? .visible : .hidden, for: .navigationBar)
            .toolbarColorScheme(isPastHeader ? colorScheme : nil, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                        .opacity(isPastHeader ? 1 : 0)
                }
            }
    }
}

extension View {
    func heroNavigationBar(title: String, headerHeight: CGFloat) -> some View {
        modifier(HeroNavigationBar(title: title, headerHeight: headerHeight))
    }
}
