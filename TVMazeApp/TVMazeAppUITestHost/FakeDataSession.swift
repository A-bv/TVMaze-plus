//
//  FakeDataSession.swift
//  TVMazeAppUITestHost
//
//  Created by Alexandre Bevilacqua on 18.11.2026.
//

import Foundation

struct FakeDataSession: DataSession {
    private enum Constants {
        static let noResultsSearch = "nothing"
        static let failingSearch = "fail"
        static let upNextEmbed = "nextepisode"
        static let successCode = 200
        static let failureCode = 500
        static let emptyList = Data("[]".utf8)
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        guard let url = request.url else { throw URLError(.badURL) }
        let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        let search = query.first { $0.name == "q" }?.value
        let embeds = query.compactMap(\.value)

        if search == Constants.failingSearch {
            return (Data(), response(for: url, code: Constants.failureCode))
        }
        if search == Constants.noResultsSearch {
            return (Constants.emptyList, response(for: url, code: Constants.successCode))
        }
        guard let name = responseName(for: url.path, embeds: embeds),
              let file = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        return (try Data(contentsOf: file), response(for: url, code: Constants.successCode))
    }

    private func responseName(for path: String, embeds: [String]) -> String? {
        switch path {
        case "/search/shows": "girls_search_response"
        case "/search/people": "people_search_response"
        case "/schedule": "schedule_response"
        case "/schedule/web": "web_schedule_response"
        case let path where path.hasSuffix("/castcredits"): "person_cast_credits_response"
        case let path where path.hasSuffix("/crewcredits"): "person_crew_credits_response"
        case let path where path.hasSuffix("/guestcastcredits"): "person_guest_credits_response"
        case let path where path.hasPrefix("/episodes/"): "episode_detail_response"
        case let path where path.hasPrefix("/shows/"):
            embeds.contains(Constants.upNextEmbed) ? "show_up_next_response" : "show_detail_response"
        default: nil
        }
    }

    private func response(for url: URL, code: Int) -> URLResponse {
        HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil) ?? URLResponse()
    }
}
