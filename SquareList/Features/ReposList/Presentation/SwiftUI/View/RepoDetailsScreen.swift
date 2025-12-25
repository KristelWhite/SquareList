//
//  RepoDetailsScreen.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

struct RepoDetailsScreen: View {
    let repo: Repo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(repo.name)
                    .font(.title2)
                    .bold()

                if let description = repo.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                } else {
                    Text("No description")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
