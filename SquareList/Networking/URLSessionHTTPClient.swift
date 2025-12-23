//
//  URLSessionHTTPClient.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: URLRequest) async -> Result<(Data, HTTPURLResponse), NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                return .failure(.emptyResponse)
            }
            return .success((data, http))
        } catch {
            return .failure(.transportError(error.localizedDescription))
        }
    }
}
