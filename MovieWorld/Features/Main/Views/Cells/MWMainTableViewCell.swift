//
//  MWMainTableViewCell.swift
//  MovieWorld
//
//  Created by Murad on 2/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainTableViewCell: UITableViewCell {
    // MARK: - variables
    static let reuseIdentifier = "mainTableCell"
    public var movies: [APIMovie] = []
    public var title: String? {
        didSet {
            self.label.text = self.title
        }
    }
    private let sectionConstaints = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
    // MARK: - gui variables
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "New"
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var button: UIButton = {
        var button = UIButton()
        button.setTitle("All ", for: .normal)
        button.setImage(UIImage(named: "nextArrow"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        button.backgroundColor = UIColor(named: "mainAllButtonColor")
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.makeLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    // MARK: - initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.newContentView)
        self.newContentView.addSubview(self.label)
        self.newContentView.addSubview(self.button)
        self.newContentView.addSubview(self.collectionView)
        self.updateConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
    override func updateConstraints() {
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(sectionConstaints)
        }
        self.label.snp.updateConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalTo(self.collectionView.snp.top).offset(-12)
        }
        self.button.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalTo(self.collectionView.snp.top).offset(-16)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }
    // MARK: - setters / helpers / actions / handlers / utility
    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 225)
        return layout
    }
    @objc private func allButtonTapped(_ sender: UIButton) {
        let moviesListController = MWMoviesListViewController()
        moviesListController.movies = self.movies
        MWI.shared.pushVC(vc: moviesListController)
    }
}

extension MWMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier, for: indexPath) as? MWMainCollectionViewCell else { return UICollectionViewCell() }
        cell.movie = self.movies[indexPath.row]
        return cell
    }
}
