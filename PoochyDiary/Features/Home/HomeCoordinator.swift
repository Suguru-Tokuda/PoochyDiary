//
//  HomeCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27PoochyDiary/26.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    private let dependencies: AppDependency
    private let viewModel = HomeViewModel()

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewController = HomeViewController(viewModel: viewModel)

        viewController.onAddLogButtonTap = { [weak self] in
            guard let self else { return }

            navigateToAddLogPoop()
        }

        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension HomeCoordinator {
    private func navigateToAddLogPoop() {
        let logPoopCoordinator = LogPoopCoordinator(
            navigationController,
            pet: viewModel.activePet,
            dependencies: dependencies
        )
        logPoopCoordinator.start()
        addChild(logPoopCoordinator)
    }
}
