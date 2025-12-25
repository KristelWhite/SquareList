//
//  RootView.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//

import SwiftUI

struct RootView: View {
    @State private var path = NavigationPath()
    let reposListViewModel: ReposListViewModel

    var body: some View {
        NavigationStack(path: $path) {
            ReposListScreen(viewModel: reposListViewModel, path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .repoDetails(let repo):
                        RepoDetailsScreen(repo: repo)
                    }
                }
        }
    }
}
