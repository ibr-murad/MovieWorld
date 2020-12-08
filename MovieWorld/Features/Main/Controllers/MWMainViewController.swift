//
//  MWMainViewController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainViewController: MWBaseViewController {
    // MARK: - variables
    private var results: [APIResults] = []
    private var resultsTitles: [String] = []
    private var requestUrlPaths = [
        MWMainSections.nowPlaying.getSectionModel(),
        MWMainSections.popular.getSectionModel(),
        MWMainSections.topRated.getSectionModel(),
        MWMainSections.upcoming.getSectionModel()]

    // MARK: - gui variables
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 305
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MWMainTableViewCell.self,
                           forCellReuseIdentifier: MWMainTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = self.refreshControl
        return tableView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - constraints
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchMovies {}
        self.setupController()
        self.view.addSubview(self.tableView)
        self.makeConstraints()
    }

    // MARK: - setters
    private func setupController() {
        self.controllerTitle = NSLocalizedString("mainController", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - actions
    @objc private func refresh(sender: UIRefreshControl) {
        let group = DispatchGroup()
        group.enter()
        self.results = []
        self.resultsTitles = []
        self.fetchMovies {
            group.leave()
        }

        group.notify(queue: .main) {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }

    // MARK: - request
    private func fetchMovies(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        for section in self.requestUrlPaths {
            group.enter()
            MWNetwork.shared.request(
                url: section.urlPath,
                okHandler: { [weak self] (data: APIResults, response) in
                    guard let self = self else { return }
                    self.results.append(data)
                    self.resultsTitles.append(section.title)
                    group.leave()
            }) { (error, response) in
                group.leave()
                guard let response = response else {  return }
                self.attemptRecovery(fromError: error, optionIndex: 0)
                print(response.getMessage())
                print(error.localizedDescription)
            }
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
            completion()
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MWMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MWMainTableViewCell.reuseIdentifier, for: indexPath)
        (cell as? MWMainTableViewCell)?.initCell(title: self.resultsTitles[indexPath.row],
                                                 moives: self.results[indexPath.row].movies)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviesListController = MWMoviesListViewController()
        moviesListController.initController(title: self.resultsTitles[indexPath.row],
                                            url: self.requestUrlPaths[indexPath.row].urlPath,
                                            params: [:])
        MWI.shared.pushVC(vc: moviesListController)
    }
}
