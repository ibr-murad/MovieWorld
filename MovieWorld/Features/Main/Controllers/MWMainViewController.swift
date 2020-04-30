//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainViewController: UIViewController {
    // MARK: - variables
    private var results: [APIResults] = []
    private var resultsTitles: [String] = []
    private let requestUrlPaths = ["Now playing": URLPath.nowPlaing,
                                   "Popular": URLPath.popular,
                                   "Top Rated": URLPath.topRated,
                                   "Upcoming": URLPath.upcoming]
    // MARK: - gui variables
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
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillArrays()
        self.setupController()
        self.view.addSubview(self.tableView)
        self.makeConstraints()
    }
    @objc private func refresh(sender: UIRefreshControl) {
        self.results = []
        self.resultsTitles = []
        self.fillArrays()
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    // MARK: - constraints
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // MARK: - setters / helpers / actions / handlers / utility
    private func setupController() {
        self.title = "Season"
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "accentColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    // MARK: - request
    private func fillArrays() {
        let group = DispatchGroup()
        for path in self.requestUrlPaths {
            group.enter()
            MWNetwork.shared.request(url: path.value, okHandler: { [weak self] (data: APIResults, response) in
                guard let self = self else { return }
                self.results.append(data)
                self.resultsTitles.append(path.key)
                self.tableView.reloadData()
            }) { (error, response) in
                print(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }
}

// MARK: - UITableViewDelegate
extension MWMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMainTableViewCell.reuseIdentifier, for: indexPath) as? MWMainTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.movies = results[indexPath.row].movies
        cell.title = resultsTitles[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
