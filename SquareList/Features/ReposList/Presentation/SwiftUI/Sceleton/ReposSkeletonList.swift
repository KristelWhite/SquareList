//
//  ReposSkeletonList.swift
//  SquareList
//
//  Created by Кристина on 25.12.2025.
//


import SwiftUI

struct ReposSkeletonList: View {
    let count: Int

    var body: some View {
        List(0..<count, id: \.self) { _ in
            ReposSkeletonRow()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .accessibilityHidden(true)
    }
}

private struct ReposSkeletonRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 180, height: 16)

            RoundedRectangle(cornerRadius: 6)
                .frame(height: 14)
                .opacity(0.8)

            RoundedRectangle(cornerRadius: 6)
                .frame(width: 240, height: 14)
                .opacity(0.6)
        }
        .padding(.vertical, 10)
        .foregroundStyle(Color.secondary.opacity(0.5))
        .redacted(reason: .placeholder)
        .shimmer()
    }
}
