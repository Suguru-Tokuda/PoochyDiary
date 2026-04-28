//
//  MainCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

class MainCoordinator: BaseCoordinator {
    override func start() {
        let tabCoordinator = TabCoordinator(navigationController)
        tabCoordinator.start()
        addChild(tabCoordinator)
    }
}
