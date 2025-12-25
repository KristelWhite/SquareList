//
//  ReposListRenderState.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import Foundation

/// UI render state for the screen.
/// Keeps SwiftUI View simple and predictable.
enum ReposListRenderState: Equatable {
    case loading
    case content([Repo])
    case placeholder(PlaceholderModel)
}

/// UI-only model for empty/error placeholders.
struct PlaceholderModel: Equatable {
    let systemImage: String
    let title: String
    let message: String
    let showsRetry: Bool
}

extension PlaceholderModel {
    static let empty = PlaceholderModel(
        systemImage: "tray",
        title: "No repositories",
        message: "Pull to refresh or try again later.",
        showsRetry: false
    )

    static func error(_ error: UserFacingError) -> PlaceholderModel {
        PlaceholderModel(
            systemImage: error.systemImageName,
            title: error.title,
            message: error.message,
            showsRetry: true
        )
    }
}
