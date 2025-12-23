//
//  Endpoint.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]

    func makeRequest() -> Result<URLRequest, NetworkError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else { return .failure(.invalidURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        // GitHub иногда просит явно Accept, пусть будет.
        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        }

        return .success(request)
    }
}
