//
//  GitHubRepoMapper.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

import Foundation

enum GitHubRepoMapper {
    static func map(_ dto: GitHubRepoDTO) -> Repo {
        Repo(id: dto.id, name: dto.name, description: dto.description)
    }
}
