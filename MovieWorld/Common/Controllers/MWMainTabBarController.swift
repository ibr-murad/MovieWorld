//
//  MWMainTabBarController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWMainTabBarController: UITabBarController {
    // MARK: - variables
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainTab = MWMainViewController()
        mainTab.tabBarItem = UITabBarItem(title: "Main", image: UIImage(named: "mainTab"), tag: 0)
        let categoryTab = MWCategoryViewControler()
        categoryTab.tabBarItem = UITabBarItem(title: "Gategory", image: UIImage(named: "categoryTab"), tag: 1)
        let searchTab = MWSearchViewController()
        searchTab.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchTab"), tag: 2)
        let tabs = [mainTab, categoryTab, searchTab]
        //create and set UINavigationController for each viewController
        self.viewControllers = tabs.map { UINavigationController(rootViewController: $0)}
        tabBarStyle()
    }
    // MARK: - setters / helpers / actions / handlers / utility
    private func tabBarStyle() {
        self.tabBar.tintColor = UIColor(named: "activeTabBarItemColor")
        self.tabBar.barTintColor = .none
    }
}
