//
//  LogPoopCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class LogPoopCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = LogPoopViewModel()
        let viewController = LogPoopViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
