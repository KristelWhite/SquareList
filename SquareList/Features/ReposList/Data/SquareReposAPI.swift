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
    private let builder = RequestBuilder()

    init(client: HTTPClient, decoder: JSONDecoder = .init()) {
        self.client = client
        self.decoder = decoder
    }

    func fetchSquareRepos(page: Int, perPage: Int, policy: FetchPolicy) async -> Result<[Repo], NetworkError> {

        let endpoint = GitHubEndpoint.squareRepos(page: page, perPage: perPage)

        let request: URLRequest
        do {
            request = try builder.makeRequest(
                from: endpoint,
                cachePolicy: cachePolicy(for: policy)
            )
        } catch {
            return .failure(.invalidURL)
        }

        let result = await client.send(request)

        switch result {
        case .failure(let error):
            return .failure(error)

        case .success(let (data, response)):
            guard (200...299).contains(response.statusCode) else {
                return .failure(.server(statusCode: response.statusCode))
            }

            do {
                let dto = try decoder.decode([GitHubRepoDTO].self, from: data)
                return .success(dto.map(GitHubRepoMapper.map))
            } catch {
                return .failure(.decoding(error))
            }
        }
    }

    private func cachePolicy(for policy: FetchPolicy) -> URLRequest.CachePolicy {
        switch policy {
        case .initial:
            return .returnCacheDataElseLoad
        case .refresh:
            return .reloadIgnoringLocalCacheData
        case .nextPage:
            return .useProtocolCachePolicy
        }
    }
}
