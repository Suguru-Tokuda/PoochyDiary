//
//  HistoryCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class HistoryCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = HistoryViewModel()
        let viewController = HistoryViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
