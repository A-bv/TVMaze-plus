//
//  ShowSearchViewModel.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 30.09.2026.
//

import Observation
import Foundation

@Observable
final class ShowSearchViewModel {
    
    private let service: TVMazeAPIService
    private let transformer: ShowSearchTransformer
    
    var shows: [ShowItemModel] = []
    var isLoading: Bool = false
    var apiError: TVMazeAPIServiceError?
    var unexpectedError: Error?
    var isShowingAlert: Bool = false

    init(service: TVMazeAPIService,
         transformer: ShowSearchTransformer = ShowSearchTransformer()) {
        self.service = service
        self.transformer = transformer
    }
    
    func loadShows(entry: String) async {
        isLoading = true
        do {
            let results = try await service.fetchShowsFromAPI(show: entry)
            if Task.isCancelled { return }
            shows = transformer.transform(results)
            apiError = nil
            unexpectedError = nil
        } catch let error as TVMazeAPIServiceError {
            if Task.isCancelled { return }
            shows = []
            apiError = error
            isShowingAlert = true
        } catch {
            if Task.isCancelled { return }
            shows = []
            unexpectedError = error
            isShowingAlert = true
        }
        isLoading = false
    }
}
