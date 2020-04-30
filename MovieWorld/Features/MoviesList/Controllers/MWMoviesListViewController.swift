//
//  MWAllMoviesViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/17/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWMoviesListViewController: UIViewController {
    // MARK: - variables
    private var genres = [Genre]()
    public var movies: [APIMovie] = []
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
        MWPersistenceService.shared.requestGenres { [weak self] (data) in
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
    // MARK: - setters / helpers / actions / handlers / utility
    private func setupController() {
        self.title = "Movies"
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "accentColor")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc private func refresh(sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
}

extension MWMoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMoviesListTableViewCell.reuseIdentifier, for: indexPath) as? MWMoviesListTableViewCell else { return UITableViewCell() }
        cell.genres = self.genres
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.movie = movies[indexPath.row]
        /*
         let backGroundColor = UIView()
         backGroundColor.backgroundColor = .clear
         cell.selectedBackgroundView = backGroundColor
         //cell rounded corners and shadow
         cell.mainView.layer.borderWidth = 1
         cell.mainView.layer.cornerRadius = 5
         cell.mainView.layer.borderColor = UIColor.clear.cgColor
         cell.mainView.layer.masksToBounds = true
         cell.mainView.layer.shadowOpacity = 0.2
         cell.mainView.layer.shadowOffset = CGSize(width: 0, height: 4)
         cell.mainView.layer.shadowRadius = 5
         cell.mainView.layer.shadowColor = UIColor.black.cgColor
         cell.mainView.layer.masksToBounds = false
         */
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MWInterface.shared.pushVC(vc: MWDetailsViewConroller())
    }
}

extension MWMoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UICollectionViewDelegate
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
}

/*extension MWMoviesListViewController: UICollectionViewDelegateFlowLayout {
 
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 let label = UILabel()
 label.text = self.category[indexPath.row]
 return CGSize(width: label.intrinsicContentSize.width, height: 26)}
 }*/
