//
//  PagingState.swift
//  SquareList
//
//  Created by Кристина on 26.12.2025.
//

import Foundation

/// Paging state holder for list screens.
struct PagingState {
    var page: Int = 1
    let perPage: Int
    var canLoadMore: Bool = true
    var isLoading: Bool = false

    init(perPage: Int) {
        self.perPage = perPage
    }

    mutating func reset() {
        page = 1
        canLoadMore = true
    }

    mutating func advance(receivedCount: Int) {
        if receivedCount < perPage {
            canLoadMore = false
        } else {
            page += 1
        }
    }
}
