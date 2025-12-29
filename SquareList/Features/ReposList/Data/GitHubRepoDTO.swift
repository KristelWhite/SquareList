//
//  GitHubRepoDTO.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

import Foundation

struct GitHubRepoDTO: Decodable {
    let id: Int
    let name: String
    let description: String?
}
