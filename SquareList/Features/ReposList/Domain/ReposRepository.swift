//
//  ReposRepository.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

import Foundation

protocol ReposRepository {
    func fetchSquareRepos(
        page: Int,
        perPage: Int,
        policy: FetchPolicy
    ) async -> Result<[Repo], NetworkError>
}
