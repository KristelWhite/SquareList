//
//  SquareReposAPI.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import Foundation

final class SquareReposAPI: ReposRepository {
    private let client: HTTPClient
    private let decoder: JSONDecoder

    init(client: HTTPClient, decoder: JSONDecoder = JSONDecoder()) {
        self.client = client
        self.decoder = decoder
    }

    func fetchSquareRepos(page: Int, perPage: Int) async -> Result<[Repo], NetworkError> {
        let endpoint = Endpoint(
            path: "/orgs/square/repos",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        )

        let requestResult = endpoint.makeRequest()
        switch requestResult {
        case .failure(let error):
            return .failure(error)
        case .success(let request):
            let result = await client.send(request)
            switch result {
            case .failure(let error):
                return .failure(error)
            case .success(let (data, response)):
                guard (200...299).contains(response.statusCode) else {
                    return .failure(.serverError(statusCode: response.statusCode))
                }

                do {
                    let dtos = try decoder.decode([GitHubRepoDTO].self, from: data)
                    let repos = dtos.map(GitHubRepoMapper.map)
                    return .success(repos)
                } catch {
                    return .failure(.decodingError(error.localizedDescription))
                }
            }
        }
    }
}
