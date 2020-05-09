//
//  MWCategoryViewControler.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWCategoryViewControler: MWBaseViewController {
    // MARK: - variables
    private let reuseIdentifier = "MWCategoryTableCell"
    private var genres: [Genre] = []
    
    // MARK: - gui variables
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        self.makeConstraintsForTableView()
        MWSystem.shared.requestGenres { [weak self] (data) in
            guard let self = self else { return }
            self.genres = data
            self.tableView.reloadData()
        }
    }
    
    // MARK: - constraints
    private func makeConstraintsForTableView() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - setters
    private func setupController() {
        self.controllerTitle = "Category"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWCategoryViewControler: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: self.reuseIdentifier)
        let accessoryImage = UIImageView(image: UIImage(named: "deteilIcon"))
        cell.accessoryView = accessoryImage
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.font = .systemFont(ofSize: 17)
        cell.textLabel?.text = genres[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviesListController = MWMoviesListViewController()
        MWNetwork.shared.request(
            url: MWURLPath.discoverMovie,
            param: "&with_genres=\(self.genres[indexPath.row].id)",
            okHandler: { (data: APIResults, response) in
                moviesListController.movies = data.movies
        }) { (error, response) in
            print(error.localizedDescription)
        }
        MWI.shared.pushVC(vc: moviesListController)
    }
}
