//
//  AppCoordinator.swift
//  SquareList
//
//  Created by Кристина on 23.12.2025.
//


import UIKit

@MainActor
protocol Coordinator {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let client = URLSessionHTTPClient()
        let repository = SquareReposAPI(client: client)
        let viewModel = ReposListViewModel(repository: repository)
        let vc = ReposListViewController(viewModel: viewModel)

        navigationController.viewControllers = [vc]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
