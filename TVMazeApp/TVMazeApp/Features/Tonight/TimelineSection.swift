//
//  TimelineSection.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct TimelineSection: View {
    private enum Constants {
        static let emptyMessage = String(localized: "No evening listings on this day.")
        static let separator = " · "
    }

    let title: String
    let country: String
    let timeZone: TimeZone
    let timeSlots: [TimeSlotItemModel]

    var body: some View {
        DetailSection(title: title) {
            Text(verbatim: caption)
                .font(.subheadline)
                .foregroundStyle(.secondaryText)
            if timeSlots.isEmpty {
                Text(Constants.emptyMessage)
                    .foregroundStyle(.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
            ForEach(timeSlots) { timeSlot in
                if timeSlot.id != timeSlots.first?.id {
                    Divider()
                }
                TimeSlotView(timeSlot: timeSlot, timeZone: timeZone)
            }
        }
    }

    private var caption: String {
        [country, timeZone.localizedName(for: .generic, locale: .current)]
            .compactMap { $0 }
            .joined(separator: Constants.separator)
    }
}
