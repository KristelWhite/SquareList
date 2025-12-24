//
//  RequestBuilder.swift
//  SquareList
//
//  Created by Кристина on 24.12.2025.
//

import Foundation

struct RequestBuilder {

    private let host = "api.github.com"
    private let scheme = "https"

    func makeRequest(from endpoint: APIEndpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        endpoint.headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return request
    }
}
