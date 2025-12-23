//
//  MockHTTPClient.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation
@testable import SquareList

final class MockHTTPClient: HTTPClient {

    var result: Result<(Data, HTTPURLResponse), NetworkError>?

    func send(_ request: URLRequest) async -> Result<(Data, HTTPURLResponse), NetworkError> {
        guard let result else {
            return .failure(.emptyResponse)
        }
        return result
    }
}
