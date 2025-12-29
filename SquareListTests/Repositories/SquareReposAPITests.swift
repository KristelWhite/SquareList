//
//  SquareReposAPITests.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

@testable import SquareList
import XCTest

final class SquareReposAPITests: XCTestCase {

    func test_fetchSquareRepos_success_decodesRepos() async {
        // GIVEN
        let mock = MockHTTPClient()
        let api = SquareReposAPI(client: mock)

        let json = TestDataFactory.reposJSON(items: [
            (id: 1, name: "a", description: "d"),
            (id: 2, name: "b", description: nil)
        ])

        let response = TestDataFactory.httpResponse(statusCode: 200)
        mock.result = .success((json, response))

        // WHEN
        let result = await api.fetchSquareRepos(page: 1, perPage: 30)

        // THEN
        switch result {
        case .failure(let error):
            XCTFail("Expected success, got \(error)")
        case .success(let repos):
            XCTAssertEqual(repos.map(\.name), ["a", "b"])
            XCTAssertEqual(repos[1].description, nil)
        }
    }
}
