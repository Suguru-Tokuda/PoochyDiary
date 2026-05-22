//
//  AppCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/28/26.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let dependencies = AppDependency()

    init(window: UIWindow) {
        self.window = window
        super.init()
        setupDependencies()
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

    private func setupDependencies() {
        dependencies.imageFileManager = ImageFileManager()
        dependencies.poochyDiaryCoreDataManager = PoochyDiaryCoreDataManager()
    }
}
