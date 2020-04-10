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
    
    static let shared = MWInterface()
    
    weak var window: UIWindow?
    private lazy var tabBarController = MWMainTabBarController()
    
    private init() {}
    
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
        
        /* //for iOS 13
        let newNavBar = UINavigationBarAppearance()
        newNavBar.configureWithDefaultBackground()
        standartNavBar.scrollEdgeAppearance = newNavBar
         */
    }
    
    func pushVC(vc: UIViewController) {
        guard let navigationController =
            self.tabBarController.selectedViewController as? UINavigationController else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        guard let navigationController =
            self.tabBarController.selectedViewController as? UINavigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
