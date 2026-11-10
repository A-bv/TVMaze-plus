//
//  FavoritesViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import Foundation
import Observation

@Observable
final class FavoritesViewModel {
    private let service: TVMazeAPIService
    private let transformer = UpNextTransformer()
    private var loadedShowIDs: Set<Int> = []
    private var upNextByShow: [Int: UpNextItemModel] = [:]

    private(set) var upNext: [UpNextItemModel] = []

    init(service: TVMazeAPIService = TVMazeAPIServiceImpl()) {
        self.service = service
    }

    func loadUpNext(showIDs: [Int]) async {
        for showID in showIDs where !loadedShowIDs.contains(showID) {
            guard let model = try? await service.fetchUpNext(showID: showID) else { continue }
            if Task.isCancelled { return }
            loadedShowIDs.insert(showID)
            upNextByShow[showID] = transformer.transform(model)
        }
        upNext = showIDs
            .compactMap { upNextByShow[$0] }
            .sorted { $0.airDate < $1.airDate }
    }
}
