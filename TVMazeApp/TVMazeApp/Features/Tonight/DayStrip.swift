//
//  DayStrip.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import NeumorphicSwiftUI
import SwiftUI

struct DayStrip: View {
    private enum Constants {
        static let spacing: CGFloat = 6
        static let textSpacing: CGFloat = 4
    }

    let days: [Date]
    @Binding var selectedDay: Date

    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(days, id: \.self) { day in
                Toggle(isOn: Binding(
                    get: { selectedDay == day },
                    set: { _ in selectedDay = day }
                )) {
                    VStack(spacing: Constants.textSpacing) {
                        Text(day.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(day.formatted(.dateTime.day()))
                            .font(.headline)
                            .foregroundStyle(selectedDay == day ? Color.accentColor : Color.primary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .toggleStyle(NeumorphicToggleStyle())
                .accessibilityLabel(day.formatted(date: .complete, time: .omitted))
            }
        }
    }
}
