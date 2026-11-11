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
        static let textSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let weekdayKerning: CGFloat = 0.5
    }

    let days: [Date]
    @Binding var selectedDay: Date

    var body: some View {
        ViewThatFits(in: .horizontal) {
            strip
            ScrollView(.horizontal) {
                strip
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
        .transformEnvironment(\.neumorphicMetrics) { metrics in
            metrics.cornerRadius = Constants.cornerRadius
        }
    }

    private var strip: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                Toggle(isOn: Binding(
                    get: { selectedDay == day },
                    set: { _ in selectedDay = day }
                )) {
                    VStack(spacing: Constants.textSpacing) {
                        Text(day.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2.weight(.semibold))
                            .textCase(.uppercase)
                            .kerning(Constants.weekdayKerning)
                            .foregroundStyle(.secondaryText)
                        Text(day.formatted(.dateTime.day()))
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(selectedDay == day ? Color.accentColor : Color.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Constants.verticalPadding)
                }
                .toggleStyle(NeumorphicToggleStyle())
                .accessibilityLabel(day.formatted(date: .complete, time: .omitted))
            }
        }
    }
}
