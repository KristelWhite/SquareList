//
//  APIEndpoint.swift
//  SquareList
//
//  Created by Кристина on 24.12.2025.
//

import Foundation

protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
}
