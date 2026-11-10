//
//  View+SoftTile.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

extension View {
    func softTile(cornerRadius: CGFloat) -> some View {
        background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.surface)
                .neumorphicShadow()
        }
    }
}
