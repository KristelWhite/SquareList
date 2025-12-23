//
//  ReposListViewController.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import UIKit

final class ReposListViewController: UIViewController {

    private let viewModel: ReposListViewModel

    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Int, Repo>!

    private let loader = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let emptyStack = UIStackView()

    private let refreshControl = UIRefreshControl()
    private let footerSpinner = UIActivityIndicatorView(style: .medium)

    init(viewModel: ReposListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Square Repositories"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTable()
        setupStateViews()
        bind()

        Task { await viewModel.loadInitial() }
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = refreshControl
        tableView.delegate = self

        footerSpinner.hidesWhenStopped = true
        tableView.tableFooterView = footerSpinner

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        dataSource = UITableViewDiffableDataSource<Int, Repo>(tableView: tableView) { tableView, indexPath, repo in
            let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseId, for: indexPath) as! RepoCell
            cell.configure(name: repo.name, description: repo.description)
            return cell
        }

        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }

    private func setupStateViews() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)

        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center

        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        emptyStack.axis = .vertical
        emptyStack.spacing = 12
        emptyStack.alignment = .center
        emptyStack.translatesAutoresizingMaskIntoConstraints = false
        emptyStack.isHidden = true

        emptyStack.addArrangedSubview(messageLabel)
        emptyStack.addArrangedSubview(retryButton)

        view.addSubview(emptyStack)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func bind() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state: state)
        }

        viewModel.onDataChange = { [weak self] in
            self?.applySnapshot()
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Repo>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.repos, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func render(state: ReposListViewState) {
        switch state {
        case .idle:
            loader.stopAnimating()
            emptyStack.isHidden = true
            footerSpinner.stopAnimating()

        case .loading:
            emptyStack.isHidden = true
            loader.startAnimating()
            footerSpinner.stopAnimating()

        case .content:
            loader.stopAnimating()
            emptyStack.isHidden = true
            refreshControl.endRefreshing()
            footerSpinner.stopAnimating()

        case .empty:
            loader.stopAnimating()
            refreshControl.endRefreshing()
            footerSpinner.stopAnimating()
            messageLabel.text = "No repositories found."
            retryButton.isHidden = true
            emptyStack.isHidden = false

        case .failure(let message):
            loader.stopAnimating()
            refreshControl.endRefreshing()
            footerSpinner.stopAnimating()
            messageLabel.text = message
            retryButton.isHidden = false
            emptyStack.isHidden = false
        }
    }

    @objc private func didTapRetry() {
        Task { await viewModel.retry() }
    }

    @objc private func didPullToRefresh() {
        Task { await viewModel.refresh() }
    }
}

extension ReposListViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Когда дошли почти до низа — догружаем.
        if offsetY > contentHeight - frameHeight - 200 {
            footerSpinner.startAnimating()
            Task { [weak self] in
                guard let self else { return }
                let lastIndex = max(self.viewModel.repos.count - 1, 0)
                await self.viewModel.loadNextPageIfNeeded(currentIndex: lastIndex)
            }
        }
    }
}
