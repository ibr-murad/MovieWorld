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
    private var params: [String: String] = [:]
    private var movies: [APIMovie] = []
    private var genres: [Genre] = []
    private var filteredGenres: [Bool] = []
    private var page: Int = 1
    private var totalPages: Int = 0
    private var totalResults: Int = 0
    private var requestMore: Bool = false
    private var oldUrl: String = ""
    private var url: String = "" {
        didSet {
            self.loadMovies()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - gui variables
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.register(MWGroupstCollectionViewCell.self,
                                forCellWithReuseIdentifier: MWGroupstCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var collectionViewLayout: MWGroupsCollectionViewLayout = {
        let layout = MWGroupsCollectionViewLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MWMoviesListTableViewCell.self,
                           forCellReuseIdentifier: MWMoviesListTableViewCell.reuseIdentifier)
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
    
    // MARK: - initialization
    func initController(url: String, params: [String: String]) {
        self.params = params
        self.url = url
        self.oldUrl = url
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
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
        self.makeConstraints()
        MWSystem.shared.requestGenres { [weak self] (data) in
            guard let self = self else { return }
            self.genres = data
            self.filteredGenres = Array(repeating: false, count: data.count)
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: -actions
    @objc private func refresh(sender: UIRefreshControl) {
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    
    // MARK: -requests
    private func loadMovies() {
        let group = DispatchGroup()
        group.enter()
        self.params.merge(["page": "\(self.page)"]) { (_, new) in new }
        self.requestMore = true
        MWNetwork.shared.request(url: self.url,
            params: self.params,
            okHandler: { [weak self] (data: APIResults, response) in
                guard let self = self else { return }
                self.movies.append(contentsOf: data.movies)
                self.totalPages = data.totalPages
                self.totalResults = data.totalResults
                group.leave()
        }) { (error, response) in
            print(error)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.page += 1
            self.tableView.reloadData()
            self.requestMore = false
        }
    }
    
    private func filteringByGeres() {
        var genresId: [Int32] = []
        for i in 0..<self.filteredGenres.count {
            if self.filteredGenres[i] {
                genresId.append(self.genres[i].id)
            }
        }
        if genresId.count != 0 {
            var requestId: String = ""
            for id in genresId { requestId += "\(id)," }
            self.movies = []
            self.page = 1
            self.params.merge(["with_genres": "\(requestId)"]) { (_, new) in new }
            self.url = MWURLPath.discoverMovie
        } else {
            self.movies = []
            self.page = 1
            self.url = self.oldUrl
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWMoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: MWMoviesListTableViewCell.reuseIdentifier, for: indexPath) as? MWMoviesListTableViewCell else { return UITableViewCell() }
        if self.movies.count != 0 {
            cell.initView(movie: self.movies[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deteilController = MWDetailsViewConroller()
        deteilController.initController(movieId: self.movies[indexPath.row].id)
        MWInterface.shared.pushVC(vc: deteilController)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight =  scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * 1.5 {
            if !self.requestMore, self.page < self.totalPages {
                self.loadMovies()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWMoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: MWGroupstCollectionViewCell.reuseIdentifier,
            for: indexPath)  as? MWGroupstCollectionViewCell else { return UICollectionViewCell()}
        cell.setCategory(self.genres[indexPath.row].name)
        
        if self.filteredGenres[indexPath.row] {
            cell.conteinerView.alpha = 1
        } else {
            cell.conteinerView.alpha = 0.5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.filteredGenres[indexPath.row] {
            self.filteredGenres[indexPath.row] = false
        } else {
            self.filteredGenres[indexPath.row] = true
        }
        self.filteringByGeres()
        self.collectionView.reloadData()
    }
}

// MARK: - MWGroupsCollectionViewLayout
extension MWMoviesListViewController: MWGroupsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.text = self.genres[indexPath.row].name
        return label.intrinsicContentSize.width
    }
}
