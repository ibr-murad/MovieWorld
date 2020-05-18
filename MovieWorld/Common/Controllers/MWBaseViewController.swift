//
//  MWBaseViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/5/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWBaseViewController: UIViewController {
    // MARK: - variables
    var controllerTitle: String? {
        get {
            return self.navigationItem.title
        }
       set {
            self.navigationItem.title = newValue
            self.navigationController?.navigationBar.backItem?.title = " "
        }
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initController()
    }

    // MARK: - setters
    private func initController() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "accentColor")
    }
}
