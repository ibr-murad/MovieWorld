//
//  MWMainTabBarController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainTabBarController: UITabBarController {
    // MARK: - gui variables
    private lazy var mainTab: MWMainViewController = {
        let controller = MWMainViewController()
        controller.tabBarItem = UITabBarItem(
            title: NSLocalizedString("mainTab", comment: ""),
            image: UIImage(named: "mainTab"), tag: 0)
        return controller
    }()

    private lazy var categoryTab: MWCategoryViewControler = {
        let controller = MWCategoryViewControler()
        controller.tabBarItem = UITabBarItem(
            title: NSLocalizedString("categoryTab", comment: ""),
            image: UIImage(named: "categoryTab"), tag: 1)
        return controller
    }()

    private lazy var searchTab: MWSearchViewController = {
        let controller = MWSearchViewController()
        controller.tabBarItem = UITabBarItem(
            title: NSLocalizedString("searchTab", comment: ""),
            image: UIImage(named: "searchTab"), tag: 2)
        return controller
    }()

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabs = [self.mainTab, self.categoryTab, self.searchTab]
        self.viewControllers = tabs.map { UINavigationController(rootViewController: $0)}
        self.tabBarStyle()
    }

    // MARK: - setters
    private func tabBarStyle() {
        self.tabBar.tintColor = UIColor(named: "activeTabBarItemColor")
        self.tabBar.barTintColor = .none
    }
}
