//
//  MWCategoryViewControler.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWCategoryViewControler: UIViewController {
    
    private var data = Array(repeating: "Top 250", count: 20)
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    private let cellIdentifier = "categoryesCell"
    private lazy var tableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Category"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //tableView setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        makeConstraintsForTableView()
    }
    
    private func makeConstraintsForTableView() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension MWCategoryViewControler: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        return cell
    }
}

