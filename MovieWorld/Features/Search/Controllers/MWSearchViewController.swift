//
//  MWSearchViewController.swift
//  MovieWorld
//
//  Created by Murad on 2/23/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWSearchViewController: MWBaseViewController {
    
    // MARK: - Private Variables
    private var movies: [APIMovie] = []
    private var params: [String: String] = [:]
    private var page: Int = 1
    private var totalPages: Int = 0
    private var totalResults: Int = 0
    private var isRequestBusy: Bool = false
    private var isSearchByWithFilter: Bool = false
    
    // MARK: - GUI Variables
    private lazy var searchController: UISearchController = {
        var searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        var searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.tintColor = UIColor(named: "accentColor")
        searchBar.placeholder = "Search..."
        return searchController
    }()
    
    private lazy var filterBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            image: UIImage(named: "filterIcon"),
            style: .plain, target: self, action: #selector(self.filterButtonTapped))
        button.tintColor = UIColor(named: "accentColor")
        return button
    }()
    
    private lazy var centerLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        label.text = "Enter a request or configure a filter"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            MWMoviesListTableViewCell.self,
            forCellReuseIdentifier: MWMoviesListTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupController()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupSubviews()
        self.makeConstroints()
    }
    
    // MARK: - Actions
    @objc private func filterButtonTapped() {
        let controller = MWFilterViewController()
        controller.filterParamsHandler = { [weak self] params in
            guard let self = self else { return }
            self.params = params
            self.movies = []
            self.resetProperties()
            self.isSearchByWithFilter = true
            self.loadMoviesWithFilter()
            self.isCentralLabelHiden()
        }
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController?.dismiss(animated: true, completion: {
            MWInterface.shared.pushVC(vc: controller)
        })
    }
    
    // MARK: - Requests
    private func loadMovies() {
        guard let text = self.searchController.searchBar.text,
            !self.isSearchByWithFilter else { return }
        let group = DispatchGroup()
        group.enter()
        self.isRequestBusy = true
        MWNetwork.shared.request(
            url: MWURLPath.searchMovie,
            params: ["query": text, "page": "\(self.page)"],
            okHandler: { [weak self] (result: APIResults, _) in
                guard let self = self else { return }
                self.movies.append(contentsOf: result.movies)
                self.totalPages = result.totalPages
                self.totalResults = result.totalResults
                group.leave()
        }) { (error, _) in
            print(error.localizedDescription)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.page += 1
            self.tableView.reloadData()
            self.isRequestBusy = false
        }
    }
    
    private func loadMoviesWithFilter() {
        guard self.isSearchByWithFilter else { return }
        let group = DispatchGroup()
        group.enter()
        self.params["page"] = "\(self.page)"
        print(self.params)
        self.isRequestBusy = true
        MWNetwork.shared.request(
            url: MWURLPath.discoverMovie,
            params: self.params,
            okHandler: { [weak self] (result: APIResults, _) in
                guard let self = self else { return }
                self.movies.append(contentsOf: result.movies)
                self.totalPages = result.totalPages
                self.totalResults = result.totalResults
                group.leave()
        }) { (error, _) in
            self.isRequestBusy = false
            print(error.localizedDescription)
        }
        
        group.notify(queue: .main) {
            self.page += 1
            self.tableView.reloadData()
            self.isRequestBusy = false
        }
    }
    
    // MARK: - Constraints
    private func makeConstroints() {
        self.centerLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(self.view.bounds.width/2)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Setters
    private func setupController() {
        self.navigationItem.title = NSLocalizedString("searchController", comment: "")
        self.view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.rightBarButtonItem = self.filterBarButton
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.centerLabel)
    }
    
    private func resetProperties() {
        self.page = 1
        self.totalResults = 0
        self.totalPages = 0
        self.isRequestBusy = false
    }
    
    // MARK: - Helpers
    private func isCentralLabelHiden(_ isHiden: Bool = true) {
        if isHiden {
            UIView.animate(withDuration: 0.2) {
                self.centerLabel.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.centerLabel.alpha = 1
            }
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MWSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MWMoviesListTableViewCell.reuseIdentifier, for: indexPath)
        if self.movies.count != 0 {
            (cell as? MWMoviesListTableViewCell)?.initView(movie: self.movies[indexPath.row])
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
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !self.isRequestBusy && self.page < self.totalPages {
                if !self.isSearchByWithFilter {
                    self.loadMovies()
                } else {
                    self.loadMoviesWithFilter()
                }
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension MWSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.movies = []
        self.resetProperties()
        self.isSearchByWithFilter = false
        self.loadMovies()
        self.isCentralLabelHiden()
    }
    
}
