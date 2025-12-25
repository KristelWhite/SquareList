//
//  UserFacingError.swift
//  SquareList
//
//  Created by Кристина on 24.12.2025.
//

import Foundation

enum UserFacingError: Equatable {
    case noInternet
    case serverUnavailable
    case unauthorized
    case unknown

    var message: String {
        switch self {
        case .noInternet:
            return "No internet connection."
        case .serverUnavailable:
            return "Server is temporarily unavailable."
        case .unauthorized:
            return "You are not authorized."
        case .unknown:
            return "Something went wrong."
        }
    }
    
    var systemImageName: String {
        switch self {
        case .noInternet:
            return "wifi.exclamationmark"
        case .serverUnavailable:
            return "exclamationmark.triangle"
        case .unauthorized:
            return "lock.fill"
        case .unknown:
            return "xmark.octagon"
        }
    }

    var title: String {
        switch self {
        case .noInternet:
            return "No Connection"
        case .serverUnavailable:
            return "Server Unavailable"
        case .unauthorized:
            return "Unauthorized"
        case .unknown:
            return "Something went wrong"
        }
    }
}
