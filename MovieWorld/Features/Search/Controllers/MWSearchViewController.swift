//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWSearchViewController: MWBaseViewController {
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controllerTitle = NSLocalizedString("searchController", comment: "")
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
