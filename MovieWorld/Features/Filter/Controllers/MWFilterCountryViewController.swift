//
//  MWFilterCountryViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/24/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWFilterCountryViewController: MWBaseViewController {
    
    // MARK: - Public Variables
    var countriesHandlers: (([APICountry]) -> Void)?
    
    // MARK: - Private Variables
    private var countries: [APICountry] = []
    private var fileredCountries: [APICountry] = []
    private var selectedCointries: [APICountry] = [] {
        willSet {
            if newValue.count > 0 {
                self.selectButton.isEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self.selectButton.alpha = 1
                }
            } else {
                self.selectButton.isEnabled = false
                UIView.animate(withDuration: 0.2) {
                    self.selectButton.alpha = 0.5
                }
            }
        }
    }
    private var isFiltering: Bool = false
    
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
    
    /*private lazy var resetBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            title: "Reset", style: .plain,
            target: self, action: #selector(self.resetBarButtonTapped))
        button.tintColor = UIColor(named: "accentColor")
        return button
    }()*/
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "CountryCell")
        return tableView
    }()
    
    private lazy var selectButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(named: "accentColor")
        button.alpha = 0.5
        button.setTitle("Select", for: .normal)
        button.setTitleColor( .white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.selectButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
        self.setupNavigationBar()
        self.setupSubviews()
        self.makeConstroints()
        self.loadCountries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Actions
    @objc private func resetBarButtonTapped() {
        self.selectedCointries = []
        self.isFiltering = false
        self.searchController.isActive = false
        self.tableView.reloadData()
    }
    
    @objc private func selectButtonTapped(_ sender: UIButton) {
        self.countriesHandlers?(self.selectedCointries)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setters
    private func setupController() {
        self.controllerTitle = NSLocalizedString("searchController", comment: "")
        self.view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = self.searchController
        //self.navigationItem.rightBarButtonItem = self.resetBarButton
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.selectButton)
    }
    
    private func makeConstroints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.selectButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(16)
            if let tabHeigt = self.tabBarController?.tabBar.bounds.height {
                make.bottom.equalToSuperview().inset(tabHeigt + 16)
            } else {
                make.bottom.equalToSuperview().inset(80 + 16)
            }
        }
    }
    
    // MARK: - Request
    private func loadCountries() {
        MWNetwork.shared.request(
            url: MWURLPath.countries,
            okHandler: { [weak self] (countries: [APICountry], _) in
                guard let self = self else { return }
                self.countries.append(contentsOf: countries)
                self.tableView.reloadData()
        }) { (error, _) in
            print(error)
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWFilterCountryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.isFiltering ? self.fileredCountries.count : self.countries.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        let country = self.isFiltering ? self.fileredCountries[indexPath.row] : self.countries[indexPath.row]
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.tintColor = UIColor(named: "accentColor")
        cell.textLabel?.text = country.name
        if self.selectedCointries.contains(where: { $0.name == country.name }) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let country = self.isFiltering ? self.fileredCountries[indexPath.row] : self.countries[indexPath.row]
        if cell?.accessoryType == .some(.checkmark) {
            cell?.accessoryType = .none
            if self.selectedCointries.contains(where: { $0.name == country.name }) {
                self.selectedCointries.removeAll(where: { $0.name == country.name })
            }
        } else {
            cell?.accessoryType = .checkmark
            self.selectedCointries.append(country)
        }
    }
    
}

//MARK: - UISearchBarDelegate
extension MWFilterCountryViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isFiltering = false
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.fileredCountries = self.countries.filter({ (item: APICountry) -> Bool in
            return item.name.lowercased().contains(text.lowercased())
        })
        self.isFiltering = true
        self.tableView.reloadData()
    }
}
