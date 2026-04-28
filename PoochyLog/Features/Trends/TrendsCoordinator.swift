//
//  TrendsCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class TrendsCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = TrendsViewModel()
        let viewController = TrendsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
