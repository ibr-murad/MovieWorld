//
//  AppDelegate.swift
//  MovieWorld
//
//  Created by Murad on 2/20/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - variables
    var window: UIWindow?
    
    // MARK: - setters
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { return false}
        MWI.shared.setup(window: window)
        return true
    }
}
