//
//  NetworkError.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case transportError(String)
    case serverError(statusCode: Int)
    case decodingError(String)
    case emptyResponse
}
