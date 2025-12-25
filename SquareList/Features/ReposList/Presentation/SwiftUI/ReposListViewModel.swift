//
//  ReposListViewModel.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import Foundation

/// ViewModel for repos list with pagination.
/// Publishes a renderState so SwiftUI View stays dumb.
@MainActor
final class ReposListViewModel: ObservableObject {

    @Published private(set) var renderState: ReposListRenderState = .loading

    private let repository: ReposRepository

    private var repos: [Repo] = []
    private var state: ReposListViewState = .idle

    private var page: Int = 1
    private let perPage: Int = 30
    private var isLoadingPage = false
    private var canLoadMore = true

    init(repository: ReposRepository) {
        self.repository = repository
        syncRenderState()
    }

    func loadInitial() async {
        state = .loading
        repos.removeAll()
        page = 1
        canLoadMore = true
        syncRenderState()

        await loadNextPageInternal()
    }

    func refresh() async {
        repos.removeAll()
        page = 1
        canLoadMore = true
        syncRenderStateLoadingForRefreshIfNeeded()

        await loadNextPageInternal()
    }

    func loadNextPageIfNeeded(currentIndex: Int) async {
        guard currentIndex >= repos.count - 5 else { return }
        await loadNextPageInternal()
    }

    func retry() async {
        if repos.isEmpty {
            await loadInitial()
        } else {
            await loadNextPageInternal()
        }
    }
}

// MARK: - Private

private extension ReposListViewModel {

    func loadNextPageInternal() async {
        guard !isLoadingPage, canLoadMore else { return }
        isLoadingPage = true
        defer { isLoadingPage = false }

        let result = await repository.fetchSquareRepos(page: page, perPage: perPage)

        switch result {
        case .failure(let error):
            state = .failure(mapToUserError(error))
            syncRenderState()

        case .success(let newRepos):
            applySuccessPage(newRepos)
        }
    }

    func applySuccessPage(_ newRepos: [Repo]) {
        if page == 1, newRepos.isEmpty {
            state = .empty
            repos = []
            syncRenderState()
            return
        }

        if newRepos.count < perPage {
            canLoadMore = false
        } else {
            page += 1
        }

        repos.append(contentsOf: newRepos)
        state = .content
        syncRenderState()
    }

    func syncRenderState() {
        switch state {
        case .idle, .loading:
            // Show skeleton only when there's no content yet.
            renderState = repos.isEmpty ? .loading : .content(repos)

        case .content:
            renderState = .content(repos)

        case .empty:
            renderState = .placeholder(.empty)

        case .failure(let error):
            renderState = .placeholder(.error(error))
        }
    }

    func syncRenderStateLoadingForRefreshIfNeeded() {
        // On pull-to-refresh, we prefer native refresh spinner, not full skeleton.
        // So we keep content if it exists; otherwise show skeleton.
        renderState = repos.isEmpty ? .loading : .content(repos)
    }

    func mapToUserError(_ error: NetworkError) -> UserFacingError {
        switch error {
        case .transport:
            return .noInternet
        case .server(let code) where code == 401:
            return .unauthorized
        case .server:
            return .serverUnavailable
        default:
            return .unknown
        }
    }
}
