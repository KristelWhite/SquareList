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
        setCashe()
    }

    var body: some Scene {
        WindowGroup {
            RootView(reposListViewModel: container.reposListViewModel)
        }
    }
    
    func setCashe() {
        let memoryCapacity = 50 * 1024 * 1024
        let diskCapacity = 200 * 1024 * 1024

        URLCache.shared = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity,
            diskPath: "url_cache"
        )
    }
}

