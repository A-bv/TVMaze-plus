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
        static let timeWidth: CGFloat = 64
        static let spacing: CGFloat = 12
        static let rowSpacing: CGFloat = 14
    }

    let title: String
    let country: String
    let timeZone: TimeZone
    let timeSlots: [TimeSlotItemModel]

    var body: some View {
        DetailSection(title: title) {
            Text(country)
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
                        .padding(.leading, Constants.timeWidth + Constants.spacing)
                }
                HStack(alignment: .top, spacing: Constants.spacing) {
                    Text(timeSlot.time.formatted(Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)))
                        .font(.subheadline.weight(.bold))
                        .monospacedDigit()
                        .foregroundStyle(Color.accentColor)
                        .frame(width: Constants.timeWidth, alignment: .leading)
                    VStack(spacing: Constants.rowSpacing) {
                        ForEach(timeSlot.entries) { entry in
                            NavigationLink {
                                ShowDetailView(show: entry.show)
                            } label: {
                                ScheduleRow(entry: entry)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
