//
//  URLSessionHTTPClient.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

import Foundation

/// HTTP client backed by URLSession. Supports URLCache via injected session.
final class URLSessionHTTPClient: HTTPClient {

    private let session: URLSession = URLSessionFactory.makeCachedSession()

    func send(_ request: URLRequest) async -> Result<(Data, HTTPURLResponse), NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return .failure(.noData)
            }
            debugCacheUsage(session: session)
            return .success((data, http))
        } catch {
            return .failure(.transport(error))
        }
    }
    
    func debugCacheUsage(session: URLSession) {
        guard let cache = session.configuration.urlCache else { return }
        print("Cache: mem=\(cache.currentMemoryUsage) disk=\(cache.currentDiskUsage)")
    }
}

