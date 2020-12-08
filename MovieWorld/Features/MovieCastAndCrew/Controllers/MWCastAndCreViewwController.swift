//
//  MWCastAndCrewViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/30/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class MWCastAndCrewViewController: TabmanViewController {
    
    // MARK: - Private Variables
    private var viewControllers: [UIViewController] {
        return [self.castController, self.crewController]
    }
    private let castController = MWCastViewController()
    private let crewController = MWCrewViewController()
    private var movieId: Int = 0 {
        didSet {
            self.fetchCastAndCrew()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .progressive // Customize

        // Add to view
        self.addBar(bar, dataSource: self, at: .top)
    }
    
    // MARK: - initialization
    func initController(movieId: Int) {
        self.movieId = movieId
    }
    
    // MARK: - request
    private func fetchCastAndCrew() {
        MWNetwork.shared.request(url: "movie/\(self.movieId)/credits",
            okHandler: { [weak self] (data: APICast, response) in
                guard let self = self else { return }
                self.castController.cast = data.cast
                //self.crewController.crew = data.c
        }) { (error, response) in
            print(error)
        }
    }
    
}

extension MWCastAndCrewViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = "Page \(index)"
        return TMBarItem(title: title)
    }
    
}
