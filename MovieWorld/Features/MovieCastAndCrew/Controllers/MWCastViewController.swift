//
//  MWCastViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/30/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWCastViewController: UIViewController {
    
    // MARK: - Private Variables
    var cast: [APIActor] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - gui variables
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MWMovieCastTableViewCell.self,
                           forCellReuseIdentifier: MWMovieCastTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWCastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MWMovieCastTableViewCell.reuseIdentifier, for: indexPath)
        (cell as? MWMovieCastTableViewCell)?.initView(actor: self.cast[indexPath.row])
        return cell
    }
    
    
}
