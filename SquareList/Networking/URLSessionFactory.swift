//
//  URLSessionFactory.swift
//  SquareList
//
//  Created by Кристина on 26.12.2025.
//


import Foundation

enum URLSessionFactory {

    static func makeCachedSession() -> URLSession {
        let config = URLSessionConfiguration.default

        // This is the actual cache storage used by the session.
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "http_cache"
        )

        // Let server headers (ETag/Cache-Control) decide.
        config.requestCachePolicy = .useProtocolCachePolicy
        config.waitsForConnectivity = true

        return URLSession(configuration: config)
    }
}
