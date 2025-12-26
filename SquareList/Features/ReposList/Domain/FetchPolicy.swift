//
//  FetchPolicy.swift
//  SquareList
//
//  Created by Кристина on 26.12.2025.
//


enum FetchPolicy {
    case initial     // show cached if possible
    case refresh     // force network
    case nextPage    // normal behavior
}