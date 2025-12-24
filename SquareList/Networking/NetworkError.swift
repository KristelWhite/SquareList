//
//  NetworkError.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case server(statusCode: Int)
    case decoding(Error)
    case noData
}

