//
//  MWMovieCastAndCrewViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/12/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMovieCastAndCrewViewController: MWBaseViewController {
    // MARK: - variables
    private var movieId: Int = 0 {
        didSet {
            self.fetchCastAndCrew()
        }
    }
    private let crewCellReuseIdentifier = "MWMovieCrewTableViewCell"
    private var cast: [APIActor] = []
    private var crew: [MWCrewSection] = []

    // MARK: - gui variables
    private lazy var castTableView: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MWMovieCastTableViewCell.self,
                           forCellReuseIdentifier: MWMovieCastTableViewCell.reuseIdentifier)
        return tableView
    }()

    private lazy var crewTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.crewCellReuseIdentifier)
        return tableView
    }()

    // MARK: - initialization
    func initController(movieId: Int) {
        self.movieId = movieId
    }

    // MARK: - constraints
    private func makeConstraints() {
        self.castTableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height/2)
        }
        self.crewTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.castTableView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupController()
    }

    // MARK: - setters
    private func setupController() {
        self.controllerTitle = NSLocalizedString("castController", comment: "")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.addSubview(self.castTableView)
        self.view.addSubview(self.crewTableView)
        self.makeConstraints()
    }

    private func setCrew(data: [APICredit]) {
        let jobs: Set<String> = Set(data.map { return $0.job })
        for job in jobs {
            var persons: [APICredit] = []
            for person in data {
                if job == person.job {
                    persons.append(person)
                }
            }
            self.crew.append(MWCrewSection(title: job, crew: persons))
        }
    }

    // MARK: - request
    private func fetchCastAndCrew() {
        MWNetwork.shared.request(url: "movie/\(self.movieId)/credits",
            okHandler: { [weak self] (data: APICast, response) in
                guard let self = self else { return }
                self.cast = data.cast
                self.setCrew(data: data.crew)
                self.castTableView.reloadData()
                self.crewTableView.reloadData()
        }) { (error, response) in
            print(error)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MWMovieCastAndCrewViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.crewTableView {
            return self.crew.count
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.castTableView:
            return self.cast.count
        case self.crewTableView:
            return self.crew[section].crew.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.crewTableView {
            return self.crew[section].title
        }
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case self.castTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: MWMovieCastTableViewCell.reuseIdentifier, for: indexPath)
            (cell as? MWMovieCastTableViewCell)?.initView(actor: self.cast[indexPath.row])
            return cell
        case self.crewTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: self.crewCellReuseIdentifier, for: indexPath)
            let accessoryImage = UIImageView(image: UIImage(named: "deteilIcon"))
            cell.accessoryView = accessoryImage
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.textLabel?.font = .systemFont(ofSize: 17)
            cell.textLabel?.text = self.crew[indexPath.section].crew[indexPath.row].name
            return cell
        default:
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let castAndCrewDatailController = MWMovieCastAndCrewDetailsViewController()
        switch tableView {
        case self.castTableView:
            castAndCrewDatailController.initController(personId: self.cast[indexPath.row].id)
            break
        case self.crewTableView:
            castAndCrewDatailController.initController(personId: self.crew[indexPath.section].crew[indexPath.row].id)
            break
        default:
            print("Error: no person id")
        }
        MWInterface.shared.pushVC(vc: castAndCrewDatailController)
    }
}
