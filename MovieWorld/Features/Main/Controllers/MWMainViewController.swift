//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainViewController: UIViewController {
    
    private var results: [APIResults] = []
    private var resultsTitles: [String] = []
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 305
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MWMainTableViewCell.self, forCellReuseIdentifier: MWMainTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillArrays()
        self.title = "Season"
        self.view.addSubview(self.tableView)
        self.makeConstraints()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func fillArrays(){
        //popular
        MWNetwork.shared.request(url: URLPath.popular, okHandler: { [weak self] (data, response) in
            guard let self = self else { return }
            self.results.append(data)
            self.resultsTitles.append("Popular")
            self.tableView.reloadData()
        }) { (error, response) in
            print(error)
        }
        
        //toprated
        MWNetwork.shared.request(url: URLPath.topRated, okHandler: { [weak self] (data, response) in
            guard let self = self else { return }
            self.results.append(data)
            self.resultsTitles.append("Top rated")
            self.tableView.reloadData()
        }) { (error, response) in
            print(error)
        }
        
        //upcoming
        MWNetwork.shared.request(url: URLPath.upcoming, okHandler: { [weak self] (data, response) in
            guard let self = self else { return }
            self.results.append(data)
            self.resultsTitles.append("Upcoming")
            self.tableView.reloadData()
        }) { (error, response) in
            print(error)
        }
    }
}

extension MWMainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMainTableViewCell.reuseIdentifier, for: indexPath) as! MWMainTableViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.movies = results[indexPath.row].movies
        cell.title = resultsTitles[indexPath.row]
        return cell
    }
}

