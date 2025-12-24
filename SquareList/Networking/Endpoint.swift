//
//  Endpoint.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

enum GitHubEndpoint: APIEndpoint {
    case squareRepos(page: Int, perPage: Int)

    var path: String {
        switch self {
        case .squareRepos:
            return "/orgs/square/repos"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case let .squareRepos(page, perPage):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        }
    }

    var headers: [String : String] {
        ["Accept": "application/vnd.github+json"]
    }
}
