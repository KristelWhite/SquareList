//
//  ReposListViewModelTests.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import XCTest
@testable import SquareList

@MainActor
final class ReposListViewModelTests: XCTestCase {

    func test_loadInitial_success_setsContent_andProvidesRepos() async {
        // GIVEN
        let repos = TestDataFactory.repos(count: 2)
        let repository = StubReposRepository(result: .success(repos))
        let viewModel = ReposListViewModel(repository: repository)

        var states: [ReposListViewState] = []
        viewModel.onStateChange = { states.append($0) }

        // WHEN
        await viewModel.loadInitial()

        // THEN
        XCTAssertEqual(viewModel.repos.count, 2)
        XCTAssertTrue(states.contains(.loading))
        XCTAssertTrue(states.contains(.content))
    }

    func test_loadInitial_failure_setsFailureState() async {
        // GIVEN
        let repository = StubReposRepository(result: .failure(.serverError(statusCode: 500)))
        let viewModel = ReposListViewModel(repository: repository)

        var lastState: ReposListViewState?
        viewModel.onStateChange = { lastState = $0 }

        // WHEN
        await viewModel.loadInitial()

        // THEN
        guard case .failure(let message) = lastState else {
            XCTFail("Expected failure state")
            return
        }
        XCTAssertTrue(message.contains("500"))
        XCTAssertTrue(viewModel.repos.isEmpty)
    }
}
