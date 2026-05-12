//
//  BaseNavigationController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var isNewViewControllerBeingAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func contains(_ viewController: UIViewController) -> Bool {
        viewControllers.map { $0.className }.contains(viewController.className)
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard !isNewViewControllerBeingAdded && !contains(viewController) else { return }

        isNewViewControllerBeingAdded = true
        super.pushViewController(viewController, animated: animated)
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isNewViewControllerBeingAdded = false
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        updateNavigationBarVisibility(for: viewController, animated: animated)
    }
}

extension BaseNavigationController {
    func updateNavigationBarVisibility(
        for viewController: UIViewController,
        animated: Bool
    ) {
        guard !(viewController is UITabBarController) else { return }
        let hidden = (viewController as? NavigationBarConfigurable)?
            .prefersNavigationBarHidden ?? false

        setNavigationBarHidden(hidden, animated: animated)
    }
}
