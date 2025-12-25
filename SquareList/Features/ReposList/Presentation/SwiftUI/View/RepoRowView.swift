//
//  RepoRowView.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

struct RepoRowView: View {
    let repo: Repo

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(repo.name)
                .font(.headline)

            if let description = repo.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}
