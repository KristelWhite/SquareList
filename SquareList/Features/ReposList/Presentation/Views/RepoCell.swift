//
//  RepoCell.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import UIKit

final class RepoCell: UITableViewCell {
    static let reuseId = "RepoCell"

    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.numberOfLines = 1

        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .secondaryLabel

        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(descriptionLabel)

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(name: String, description: String?) {
        nameLabel.text = name
        if let description, !description.isEmpty {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "No description"
        }
    }
}
