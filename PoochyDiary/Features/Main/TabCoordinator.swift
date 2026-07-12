//
//  TabCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

enum TabBarPage {
    case home
    case diary
    case trends
    case profile

    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .diary
        case 2: self = .trends
        case 3: self = .profile
        default: return nil
        }
    }

    var tabTitle: String {
        switch self {
        case .home:
            return Strings.Tabs.home
        case .diary:
            return Strings.Tabs.diary
        case .trends:
            return Strings.Tabs.trends
        case .profile:
            return Strings.Tabs.profile
        }
    }

    var tabOrderNumber: Int {
        switch self {
        case .home:
            return 0
        case .diary:
            return 1
        case .trends:
            return 2
        case .profile:
            return 3
        }
    }

    var tabImage: UIImage? {
        let systemName: String
        switch self {
        case .home:
            systemName = "house.fill"
        case .diary:
            systemName = "book.closed"
        case .trends:
            systemName = "chart.xyaxis.line"
        case .profile:
            systemName = "person.crop.circle"
        }

        return UIImage(systemName: systemName)
    }
}

class TabCoordinator: BaseCoordinator {
    private var tabBarController: UITabBarController
    private var tabCoordinators: [TabBarPage: Coordinator] = [:]
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        tabBarController = UITabBarController()
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let pages: [TabBarPage] = [.home, .diary, .trends, .profile]
        let navControllers = pages
            .sorted(by: { $0.tabOrderNumber < $1.tabOrderNumber })
            .map { makeTab(for: $0) }

        tabBarController.delegate = self
        tabBarController.setViewControllers(navControllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.home.tabOrderNumber
        tabBarController.tabBar.isTranslucent = false
        configureTabBarAppearance()

        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.isNavigationBarHidden = true

        startTab(.home)
    }

    private func selectPage(_ page: TabBarPage) {
        UIView.performWithoutAnimation {
            tabBarController.selectedIndex = page.tabOrderNumber
        }
    }

    private func makeTab(for page: TabBarPage) -> UINavigationController {
        let navController = BaseNavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        navController.tabBarItem = UITabBarItem(
            title: page.tabTitle,
            image: page.tabImage,
            tag: page.tabOrderNumber
        )
        return navController
    }

    private func startTab(_ page: TabBarPage) {
        guard tabCoordinators[page] == nil,
              let navController = tabBarController.viewControllers?[safe: page.tabOrderNumber] as? UINavigationController
        else { return }

        let coordinator: Coordinator
        switch page {
        case .home:
            coordinator = HomeCoordinator(navController, dependencies: dependencies)
        case .diary:
            coordinator = DiaryCoordinator(navController, dependencies: dependencies)
        case .trends:
            coordinator = TrendsCoordinator(navController, dependencies: dependencies)
        case .profile:
            coordinator = ProfileCoordinator(navController, dependencies: dependencies)
        }

        coordinator.start()
        tabCoordinators[page] = coordinator
        addChild(coordinator)
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = PoochyTheme.surface
        appearance.shadowColor = PoochyTheme.outline

        let normalColor = PoochyTheme.secondaryText
        let selectedColor = PoochyTheme.accent

        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.tintColor = selectedColor
        tabBarController.tabBar.unselectedItemTintColor = normalColor
        tabBarController.view.backgroundColor = PoochyTheme.background
    }
}

extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let newIndex = tabBarController.viewControllers?.firstIndex(of: viewController),
              let page = TabBarPage(index: newIndex) else { return false }

        startTab(page)
        selectPage(page)

        return false
    }
}
