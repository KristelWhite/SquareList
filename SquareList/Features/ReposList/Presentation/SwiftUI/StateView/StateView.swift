//
//  StateView.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

struct StateView: View {

    struct Action {
        let title: String
        let handler: () -> Void
    }

    let placeholder: PlaceholderModel
    let primaryAction: Action?

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: placeholder.systemImage)
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text(placeholder.title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(placeholder.message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let primaryAction {
                Button(primaryAction.title) { primaryAction.handler() }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
