//
//  TestDataFactory.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation
@testable import SquareList

// Simple factory for producing deterministic test data.
enum TestDataFactory {

    // MARK: - Domain Models

    static func repo(
        id: Int = 1,
        name: String = "Repo",
        description: String? = "Description"
    ) -> Repo {
        Repo(id: id, name: name, description: description)
    }

    static func repos(count: Int) -> [Repo] {
        (0..<count).map { index in
            repo(
                id: index + 1,
                name: "Repo \(index + 1)",
                description: (index % 2 == 0) ? "Description \(index + 1)" : nil
            )
        }
    }

    // MARK: - DTO JSON (for API layer tests)

    static func reposJSON(
        items: [(id: Int, name: String, description: String?)]
    ) -> Data {
        let dicts: [[String: Any?]] = items.map { item in
            [
                "id": item.id,
                "name": item.name,
                "description": item.description
            ]
        }

        // JSONSerialization is fine for tests; keeps it simple and explicit.
        return (try? JSONSerialization.data(withJSONObject: dicts, options: []))
        ?? Data()
    }

    static func httpResponse(
        url: URL = URL(string: "https://api.github.com/orgs/square/repos")!,
        statusCode: Int = 200,
        headers: [String: String]? = nil
    ) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers
        )!
    }
}
