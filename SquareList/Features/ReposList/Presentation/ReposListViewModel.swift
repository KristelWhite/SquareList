//
//  ReposListViewModel.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

@MainActor
final class ReposListViewModel {

    private let repository: ReposRepository
    private(set) var repos: [Repo] = []

    private(set) var state: ReposListViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ReposListViewState) -> Void)?
    var onDataChange: (() -> Void)?

    private var page: Int = 1
    private let perPage: Int = 30
    private var isLoadingPage = false
    private var canLoadMore = true

    init(repository: ReposRepository) {
        self.repository = repository
    }

    func loadInitial() async {
        state = .loading
        page = 1
        canLoadMore = true
        repos.removeAll()
        await loadNextPageInternal(isRefresh: false)
    }

    func refresh() async {
        page = 1
        canLoadMore = true
        repos.removeAll()
        await loadNextPageInternal(isRefresh: true)
    }

    func loadNextPageIfNeeded(currentIndex: Int) async {
        guard currentIndex >= repos.count - 5 else { return }
        await loadNextPageInternal(isRefresh: false)
    }

    func retry() async {
        if repos.isEmpty {
            await loadInitial()
        } else {
            await loadNextPageInternal(isRefresh: false)
        }
    }

    private func loadNextPageInternal(isRefresh: Bool) async {
        guard !isLoadingPage, canLoadMore else { return }
        isLoadingPage = true
        defer { isLoadingPage = false }

        let result = await repository.fetchSquareRepos(page: page, perPage: perPage)
        switch result {
        case .failure(let error):
            state = .failure(mapToUserError(error))
        case .success(let newRepos):
            if page == 1, newRepos.isEmpty {
                state = .empty
                repos = []
                onDataChange?()
                return
            }

            if newRepos.count < perPage {
                canLoadMore = false
            } else {
                page += 1
            }

            repos.append(contentsOf: newRepos)
            state = .content
            onDataChange?()
        }
    }

    private func mapToUserError(_ error: NetworkError) -> UserFacingError {
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
