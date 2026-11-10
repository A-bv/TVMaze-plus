//
//  TonightTransformer.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation

struct TonightTransformer {
    private enum Constants {
        static let eveningStart = "18:00"
        static let streamingLimit = 10
    }

    private let showTransformer = ShowTransformer()
    private let episodeTransformer = EpisodeTransformer()

    func transform(
        schedule: [ScheduleEpisodeModel],
        webSchedule: [ScheduleEpisodeModel],
        countryCode: String
    ) -> TonightItemModel {
        let evening = schedule
            .filter { $0.show.network?.country?.code == countryCode && $0.airtime >= Constants.eveningStart }
            .sorted { $0.show.weight > $1.show.weight }
        let streaming = firstEpisodePerShow(webSchedule)
            .filter { $0.show.image != nil }
            .sorted { $0.show.weight > $1.show.weight }
            .prefix(Constants.streamingLimit)
        let pick = (evening + streaming)
            .filter { $0.show.image != nil }
            .max { $0.show.weight < $1.show.weight }

        return TonightItemModel(
            pick: pick.map(transform),
            streaming: streaming.map(transform),
            timeSlots: groupByTime(evening.map(transform)),
            timeZone: evening.first?.show.network?.country.flatMap { TimeZone(identifier: $0.timezone) } ?? .current)
    }

    private func firstEpisodePerShow(_ schedule: [ScheduleEpisodeModel]) -> [ScheduleEpisodeModel] {
        var seenShows: Set<Int> = []
        return schedule.filter { seenShows.insert($0.show.id).inserted }
    }

    private func groupByTime(_ entries: [ScheduleItemModel]) -> [TimeSlotItemModel] {
        Dictionary(grouping: entries, by: \.episode.airDate)
            .compactMap { time, entries in
                time.map { TimeSlotItemModel(time: $0, entries: entries) }
            }
            .sorted { $0.time < $1.time }
    }

    private func transform(_ entry: ScheduleEpisodeModel) -> ScheduleItemModel {
        ScheduleItemModel(
            show: showTransformer.transform(entry.show),
            episode: episodeTransformer.transform(entry.episode))
    }
}
