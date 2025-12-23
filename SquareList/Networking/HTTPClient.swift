//
//  HTTPClient.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

protocol HTTPClient {
    func send(_ request: URLRequest) async -> Result<(Data, HTTPURLResponse), NetworkError>
}
