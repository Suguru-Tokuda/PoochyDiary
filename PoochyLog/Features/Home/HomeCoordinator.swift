//
//  HomeCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27PoochyLog/26.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }
    
    override func start() {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)

        navigationController.setViewControllers([viewController], animated: false)
    }
}
