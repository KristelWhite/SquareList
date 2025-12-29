//
//  SquareListApp.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

@main
struct SquareListApp: App {
    private let container: AppContainer

    init() {
        let client = URLSessionHTTPClient()
        let repository: ReposRepository = SquareReposAPI(client: client)
        self.container = AppContainer(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            RootView(reposListViewModel: container.reposListViewModel)
        }
    }
}

