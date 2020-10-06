//
//  MWFilterViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/24/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWFilterViewController: MWBaseViewController {
    
    // MARK: - Public Variables
    var filterParamsHandler: (([String: String]) -> Void)?
    
    // MARK: - Private Variables
    private var params: [String: String] = [:] {
        willSet {
            if newValue.count > 0 {
                self.showButton.isEnabled = true
                UIView.animate(withDuration: 0.2) {
                    self.showButton.alpha = 1
                }
            } else {
                self.showButton.isEnabled = false
                UIView.animate(withDuration: 0.2) {
                    self.showButton.alpha = 0.5
                }
            }
        }
    }
    private var genres: [Genre] = []
    private var selectedGenres: [Genre] = []
    private var filteredGenres: [Bool] = []
    
    // MARK: - GUI Variables
    
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            MWGroupstCollectionViewCell.self,
            forCellWithReuseIdentifier: MWGroupstCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 44
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UITableViewCell.self, forCellReuseIdentifier: "RowsCell")
        return tableView
    }()

    private lazy var collectionViewLayout: MWGroupsCollectionViewLayout = {
        let layout = MWGroupsCollectionViewLayout()
        layout.delegate = self
        return layout
    }()

    private var rangeSlider: RangeSlider = {
        var slider = RangeSlider()
        slider.sizeToFit()
        slider.maximumValue = 10
        slider.minimumValue = 1
        slider.lowerValue = 3
        slider.upperValue = 7
        if let color = UIColor(named: "accentColor") {
            slider.trackHighlightTintColor = color
        }
        return slider
    }()
    
    private lazy var resetBarButton: UIBarButtonItem = {
        var button = UIBarButtonItem(
            title: "Reset", style: .plain,
            target: self, action: #selector(self.resetBarButtonTapped))
        button.tintColor = UIColor(named: "accentColor")
        return button
    }()
    
    private lazy var showButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(named: "accentColor")
        button.alpha = 0.5
        button.setTitle("Show", for: .normal)
        button.setTitleColor( .white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.showButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pickerView: UIView = {
        let view = UIView()
        view.frame = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height)
        view.backgroundColor = UIColor(named: "grayColor")
        view.isOpaque = true
        view.addSubview(self.picker)
        view.addSubview(self.toolBar)
        view.alpha = 0
        return view
    }()
    
    private lazy var picker: MWYearPickerView = {
        let picker = MWYearPickerView()
        picker.frame = CGRect(
            x: 0, y: self.view.frame.height - 250,
            width: UIScreen.main.bounds.width, height: 250)
        picker.backgroundColor = .white
        return picker
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(
            x: 0, y: self.view.frame.height - 250 - 45,
            width: UIScreen.main.bounds.width, height: 44)
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems(self.toolBarDoneButtons, animated: true)
        toolBar.backgroundColor = .white
        if let color = UIColor(named: "accentColor") {
            toolBar.tintColor = color
        }
        return toolBar
    }()
    
    private lazy var toolBarDoneButtons: [UIBarButtonItem] = {
        let doneButton = UIBarButtonItem(
            title: "Done", style: .plain,
            target: self, action: #selector(self.pickerDoneButtonTapped))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return [spaceButton, doneButton]
    }()
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        self.setupSubviews()
        self.makeConstroints()
        self.setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Actions
    @objc private func showButtonTapped(_ sender: UIButton) {
        self.filterParamsHandler?(self.params)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func resetBarButtonTapped() {
        self.selectedGenres = []
        for i in 0..<self.filteredGenres.count {
            self.filteredGenres[i] = false
        }
        self.params = [:]
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    @objc private func rangeSliderValueChanged(_ slider: RangeSlider) {
        let indexPath = IndexPath(row: 2, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath),
            let detailLabel = cell.detailTextLabel else { return }
        let lower = String(format: "%0.0f", slider.lowerValue.rounded())
        let upper = String(format: "%0.0f", slider.upperValue.rounded())
        detailLabel.text = "from \(lower) to \(upper)"
        self.params["vote_average.gte"] = lower
        self.params["vote_average.lte"] = upper
    }
    
    @objc private func pickerDoneButtonTapped() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.alpha = 0
        }) { (_) in
            self.pickerView.removeFromSuperview()
        }
    }
    
    // MARK: - Setters
    private func setupController() {
        self.controllerTitle = NSLocalizedString("filterController", comment: "")
        self.view.backgroundColor = .white
        self.rangeSlider.addTarget(self,
            action: #selector(self.rangeSliderValueChanged),
            for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = self.resetBarButton
    }
    
    private func setupCollectionView() {
        MWSystem.shared.requestGenres { [weak self] (data) in
            guard let self = self else { return }
            self.genres = data
            self.filteredGenres = Array(repeating: false, count: data.count)
            self.collectionView.reloadData()
        }
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.rangeSlider)
        self.view.addSubview(self.showButton)
    }
    
    private func makeConstroints() {
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview()
            make.height.equalTo(65)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(44 * 3)
        }
        self.rangeSlider.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            let width = UIScreen.main.bounds.width - 16 - 16
            make.size.equalTo(CGSize(width: width, height: 28))
        }
        self.showButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(16)
            if let tabHeigt = self.tabBarController?.tabBar.bounds.height {
                make.bottom.equalToSuperview().inset(tabHeigt + 16)
            } else {
                make.bottom.equalToSuperview().inset(80 + 16)
            }
        }
    }
    
    // MARK: - Helpers
    private func showDatePicker(at indexPath: IndexPath) {
        MWInterface.shared.tabBarController.view.addSubview(self.pickerView)
        UIView.animate(withDuration: 0.2) {
            self.pickerView.alpha = 1
        }
        self.picker.didSelectedAtRow = { [weak self] year in
            guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.text = "\(year)"
            self.params["year"] = "\(year)"
        }
    }
    
    private func showCountries(at indexPath: IndexPath) {
        let countryController = MWFilterCountryViewController()
        countryController.countriesHandlers = { [weak self] countries in
            guard let self = self else { return }
            let cell = self.tableView.cellForRow(at: indexPath)
            var names = ""
            var codes = ""
            for i in 0..<countries.count {
                names.append(countries[i].name)
                codes.append(countries[i].code)
                if i != countries.count - 1 {
                    names.append(", ")
                    codes.append(", ")
                }
            }
            cell?.detailTextLabel?.text = names
            self.params["region"] = codes
        }
        MWInterface.shared.pushVC(vc: countryController)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "RowsCell")
        let accessoryImage = UIImageView(image: UIImage(named: "detailIcon"))
        switch indexPath.row {
        case 0:
            cell.accessoryView = accessoryImage
            cell.textLabel?.text = "Country"
            break
        case 1:
            cell.accessoryView = accessoryImage
            cell.textLabel?.text = "Year"
            break
        case 2:
            cell.textLabel?.text = "Rating"
            cell.detailTextLabel?.text = "from 3 to 7"
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.showCountries(at: indexPath)
            break
        case 1:
            self.showDatePicker(at: indexPath)
            break
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWFilterViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWGroupstCollectionViewCell.reuseIdentifier,
                                                      for: indexPath)
        if let cell = cell as? MWGroupstCollectionViewCell {
            cell.setCategory(self.genres[indexPath.row].name)
            cell.conteinerView.alpha = self.filteredGenres[indexPath.row] ? 1 : 0.5
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = self.genres[indexPath.row]
        if self.filteredGenres[indexPath.row] {
            self.filteredGenres[indexPath.row] = false
            if self.selectedGenres.contains(genre) {
                self.selectedGenres.removeAll(where: {$0 == genre})
            }
        } else {
            self.selectedGenres.append(self.genres[indexPath.row])
            self.filteredGenres[indexPath.row] = true
        }
        var genresStr = ""
        for i in 0..<self.selectedGenres.count {
            genresStr.append("\(self.selectedGenres[i].id)")
            if i != self.selectedGenres.count - 1 {
                genresStr.append(", ")
            }
        }
        self.params["with_genres"] = genresStr
        self.collectionView.reloadData()
    }
}

// MARK: - MWGroupsCollectionViewLayout
extension MWFilterViewController: MWGroupsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForLabelAtIndexPath indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.text = self.genres[indexPath.row].name
        return label.intrinsicContentSize.width
    }
}
