//
//  MainCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(_ navigationController: UINavigationController,
         dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }
    
    override func start() {
        let tabCoordinator = TabCoordinator(
            navigationController,
            dependencies: dependencies
        )
        tabCoordinator.start()
        addChild(tabCoordinator)
    }
}
