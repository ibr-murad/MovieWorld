//
//  MWAllMoviesViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/17/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWMoviesListViewController: MWBaseViewController {
    // MARK: - variables
    private var genres: [Genre] = []
    var movies: [APIMovie]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - gui variables
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.register(MWMoviesListCollectionViewCell.self, forCellWithReuseIdentifier: MWMoviesListCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 63, height: 26)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MWMoviesListTableViewCell.self, forCellReuseIdentifier: MWMoviesListTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
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
        self.setupController()
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
        self.makeConstraints()
        MWSystem.shared.requestGenres { [weak self] (data) in
            guard let self = self else { return }
            self.genres = data
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - constraints
    private func makeConstraints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
            make.height.equalTo(65)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }
    // MARK: - setters
    private func setupController() {
        self.controllerTitle = "Movies"
    }
    @objc private func refresh(sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWMoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMoviesListTableViewCell.reuseIdentifier, for: indexPath) as? MWMoviesListTableViewCell else { return UITableViewCell() }
        cell.genres = self.genres
        cell.movie = movies?[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deteilController = MWDetailsViewConroller()
        deteilController.movie = movies?[indexPath.row]
        MWInterface.shared.pushVC(vc: deteilController)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWMoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: MWMoviesListCollectionViewCell.reuseIdentifier,
            for: indexPath)  as? MWMoviesListCollectionViewCell else { return UICollectionViewCell()}
        cell.setCategory(self.genres[indexPath.row].name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard let cell = collectionView.cellForItem(at: indexPath) as? MWMoviesListCollectionViewCell else { return }
        //self.collectionView.reloadData()
    }
}
