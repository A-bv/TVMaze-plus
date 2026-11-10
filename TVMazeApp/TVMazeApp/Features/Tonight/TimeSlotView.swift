//
//  TimeSlotView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct TimeSlotView: View {
    private enum Constants {
        static let collapsedCount = 3
        static let rowSpacing: CGFloat = 14
        static let peekHeight: CGFloat = 40
    }

    let timeSlot: TimeSlotItemModel
    let timeZone: TimeZone

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.rowSpacing) {
            Text(timeSlot.time.formatted(Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)))
                .font(.subheadline.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(Color.accentColor)
                .accessibilityAddTraits(.isHeader)
            ForEach(visibleEntries) { entry in
                NavigationLink {
                    ShowDetailView(show: entry.show)
                } label: {
                    ScheduleRow(entry: entry)
                }
                .buttonStyle(.plain)
            }
            if isCollapsible {
                if !isExpanded {
                    peek
                }
                ShowAllButton(count: timeSlot.entries.count, isExpanded: $isExpanded.animation())
            }
        }
    }

    private var isCollapsible: Bool {
        timeSlot.entries.count > Constants.collapsedCount
    }

    private var visibleEntries: [ScheduleItemModel] {
        isExpanded ? timeSlot.entries : Array(timeSlot.entries.prefix(Constants.collapsedCount))
    }

    private var peek: some View {
        ScheduleRow(entry: timeSlot.entries[Constants.collapsedCount])
            .frame(height: Constants.peekHeight, alignment: .top)
            .clipped()
            .mask {
                LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
            }
            .accessibilityHidden(true)
    }
}
