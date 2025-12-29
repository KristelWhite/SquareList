//
//  ReposListViewState.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//

import Foundation

enum ReposListViewState: Equatable {
    case idle
    case loading
    case content
    case empty
    case failure(UserFacingError)
}
