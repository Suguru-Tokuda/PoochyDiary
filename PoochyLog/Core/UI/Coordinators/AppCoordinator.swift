//
//  AppCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/28/26.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let dependencies = AppDependency()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let mainCoordinator = MainCoordinator(
            navigationController,
            dependencies: dependencies
        )
        mainCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        addChild(mainCoordinator)
    }
}
