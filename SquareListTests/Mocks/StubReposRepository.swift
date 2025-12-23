//
//  StubReposRepository.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation
@testable import SquareList

final class StubReposRepository: ReposRepository {

    var result: Result<[Repo], NetworkError>

    init(result: Result<[Repo], NetworkError>) {
        self.result = result
    }

    func fetchSquareRepos(page: Int, perPage: Int) async -> Result<[Repo], NetworkError> {
        return result
    }
}
