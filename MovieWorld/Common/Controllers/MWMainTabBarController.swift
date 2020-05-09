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
    // MARK: - gui variables
    private lazy var mainTab: MWMainViewController = {
        let controller = MWMainViewController()
        controller.tabBarItem = UITabBarItem(title: "Main", image: UIImage(named: "mainTab"), tag: 0)
        return controller
    }()
    
    private lazy var categoryTab: MWCategoryViewControler = {
        let controller = MWCategoryViewControler()
        controller.tabBarItem = UITabBarItem(title: "Gategory", image: UIImage(named: "categoryTab"), tag: 1)
        return controller
    }()
    
    private lazy var searchTab: MWSearchViewController = {
        let controller = MWSearchViewController()
        controller.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchTab"), tag: 2)
        return controller
    }()
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabs = [self.mainTab, self.categoryTab, self.searchTab]
        //create and set UINavigationController for each viewController
        self.viewControllers = tabs.map { UINavigationController(rootViewController: $0)}
        self.tabBarStyle()
    }
    
    // MARK: - setters
    private func tabBarStyle() {
        self.tabBar.tintColor = UIColor(named: "activeTabBarItemColor")
        self.tabBar.barTintColor = .none
    }
}
