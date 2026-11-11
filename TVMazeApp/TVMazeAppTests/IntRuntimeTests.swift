//
//  IntRuntimeTests.swift
//  TVMazeAppTests
//
//  Created by Alexandre Bevilacqua on 11.11.2026.
//

import Foundation
import Testing
@testable import TVMazeApp

@MainActor
struct IntRuntimeTests {
    private let style = Duration.UnitsFormatStyle.units(allowed: [.hours, .minutes], width: .abbreviated)

    @Test func runtimeText_underAnHour_showsTheMinutes() {
        #expect(45.runtimeText == Duration.seconds(45 * 60).formatted(style))
    }

    @Test func runtimeText_overAnHour_showsTheHoursAndMinutes() {
        #expect(75.runtimeText == (Duration.seconds(3600) + .seconds(15 * 60)).formatted(style))
    }
}
