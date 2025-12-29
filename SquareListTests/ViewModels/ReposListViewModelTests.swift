//
//  ReposListViewModelTests.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

@testable import SquareList
import XCTest
import Combine

@MainActor
final class ReposListViewModelTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func test_loadInitial_success_setsLoading_thenContent_andProvidesRepos() async {
        // GIVEN
        let repos = TestDataFactory.repos(count: 2)
        let repository = StubReposRepository(result: .success(repos))
        let viewModel = ReposListViewModel(repository: repository)

        var states: [ReposListRenderState] = []

        viewModel.$renderState
            .sink { states.append($0) }
            .store(in: &cancellables)

        // WHEN
        await viewModel.loadInitial()

        // THEN
        XCTAssertTrue(states.contains(.loading), "Expected loading state at some point")

        guard case .content(let receivedRepos) = viewModel.renderState else {
            XCTFail("Expected content state")
            return
        }
        XCTAssertEqual(receivedRepos.count, 2)
    }

    func test_loadInitial_failure_setsErrorPlaceholder_andHasNoContent() async {
        // GIVEN
        let repository = StubReposRepository(result: .failure(.server(statusCode: 500)))
        let viewModel = ReposListViewModel(repository: repository)

        // WHEN
        await viewModel.loadInitial()

        // THEN
        guard case .placeholder(.error(.serverUnavailable)) = viewModel.renderState else {
            XCTFail("Expected error placeholder state")
            return
        }
    }
}
