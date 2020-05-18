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

    // MARK: - constraints
    private func makeConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
        self.view.addSubview(tableView)
        self.makeConstraints()
        MWSystem.shared.requestGenres { [weak self] (data) in
            guard let self = self else { return }
            self.genres = data
            self.tableView.reloadData()
        }
    }

    // MARK: - setters
    private func setupController() {
        self.controllerTitle = NSLocalizedString("categoryController", comment: "")
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
        cell.textLabel?.text = genres[indexPath.row].name.capitalizingFirstLetter()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let moviesListController = MWMoviesListViewController()
        moviesListController.initController(title: self.genres[indexPath.row].name,
                                            url: MWURLPath.discoverMovie,
                                            params: ["with_genres": "\(self.genres[indexPath.row].id)"])
        MWI.shared.pushVC(vc: moviesListController)
    }
}
