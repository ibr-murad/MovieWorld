//
//  MWInterface.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

typealias MWI = MWInterface

class MWInterface {
    // MARK: - variables
    static let shared = MWInterface()
    weak var window: UIWindow?

    // MARK: - gui variables
    private lazy var tabBarController = MWMainTabBarController()

    // MARK: - initialization
    private init() {}

    // MARK: - setters
    func setup(window: UIWindow) {
        self.window = window
        window.rootViewController = self.tabBarController
        window.makeKeyAndVisible()
    }

    private func setupNavigationBarStyle() {
        let standartNavBar = UINavigationBar.appearance()
        standartNavBar.backgroundColor = .white
        standartNavBar.tintColor = UIColor(named: "accentColor")
        standartNavBar.prefersLargeTitles = true
    }

    // MARK: - helpers
    func pushVC(vc: UIViewController) {
        (self.tabBarController.selectedViewController as? UINavigationController)?
            .pushViewController(vc, animated: true)
    }

    func popVC() {
        (self.tabBarController.selectedViewController as? UINavigationController)?
            .popViewController(animated: true)
    }
}
