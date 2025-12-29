//
//  NetworkError+UserFacingError.swift
//  SquareList
//
//  Created by Кристина on 26.12.2025.
//

import Foundation

extension NetworkError {
    func toUserFacingError() -> UserFacingError {
        switch self {
        case .transport:
            return .noInternet
        case .server(let code) where code == 401:
            return .unauthorized
        case .server:
            return .serverUnavailable
        default:
            return .unknown
        }
    }
}
