//
//  Int+Runtime.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

extension Int {
    var runtimeText: String {
        Duration.seconds(self * 60).formatted(.units(allowed: [.hours, .minutes], width: .abbreviated))
    }
}
