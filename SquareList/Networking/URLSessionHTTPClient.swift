//
//  URLSessionHTTPClient.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

final class URLSessionHTTPClient: HTTPClient {

    func send(_ request: URLRequest) async -> Result<(Data, HTTPURLResponse), NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return .failure(.noData)
            }

            return .success((data, http))
        } catch {
            return .failure(.transport(error))
        }
    }
}
