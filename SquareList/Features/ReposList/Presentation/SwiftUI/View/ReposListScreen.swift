//
//  ReposListScreen.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

struct ReposListScreen: View {

    @StateObject private var viewModel: ReposListViewModel
    @Binding private var path: NavigationPath

    init(viewModel: ReposListViewModel, path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _path = path
    }

    var body: some View {
        content
            .navigationTitle("Square Repos")
            .task { await viewModel.loadInitial() }
            .animation(.easeInOut(duration: 0.2), value: viewModel.renderState)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.renderState {
        case .loading:
            ReposSkeletonList(count: 10)
                .transition(.opacity)

        case .content(let repos):
            reposList(repos)

        case .placeholder(let placeholder):
            StateView(
                placeholder: placeholder,
                primaryAction: placeholder.showsRetry
                ? .init(title: "Retry") { Task { await viewModel.retry() } }
                : nil
            )
            .transition(.opacity)
        }
    }

    private func reposList(_ repos: [Repo]) -> some View {
        List {
            ForEach(Array(repos.enumerated()), id: \.element.id) { index, repo in
                Button {
                    path.append(AppRoute.repoDetails(repo))
                } label: {
                    RepoRowView(repo: repo)
                }
                .buttonStyle(.plain)
                .task { await viewModel.loadNextPageIfNeeded(currentIndex: index) }
            }
        }
        .listStyle(.plain)
        .refreshable { await viewModel.refresh() }
    }
}
