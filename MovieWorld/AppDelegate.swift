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
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        MWI.shared.setup(window: self.window!)
        return true
    }
}
