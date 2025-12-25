//
//  AppContainer.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import Foundation

@MainActor
final class AppContainer {
    let reposListViewModel: ReposListViewModel

    init(repository: ReposRepository) {
        self.reposListViewModel = ReposListViewModel(repository: repository)
    }
}
