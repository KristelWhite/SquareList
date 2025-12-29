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

    func makeRequest(
        from endpoint: APIEndpoint,
        cachePolicy: URLRequest.CachePolicy 
    ) throws -> URLRequest {

        guard var components = URLComponents() as URLComponents? else {
            throw NetworkError.invalidURL
        }

        components.scheme = scheme
        components.host = host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.cachePolicy = cachePolicy

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
