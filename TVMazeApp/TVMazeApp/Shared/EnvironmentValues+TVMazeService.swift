//
//  EnvironmentValues+TVMazeService.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 18.11.2026.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var tvMazeService: TVMazeAPIService = TVMazeAPIServiceImpl()
}
