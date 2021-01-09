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
    static let reuseIdentifier = "MWMainTableViewCell"
    private var movies: [APIMovie] = []
    private var title: String? {
        didSet {
            self.label.text = self.title
        }
    }

    // MARK: - gui variables
    
    private lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        return view
    }()

    private lazy var label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .medium)
        return label
    }()

    private lazy var button: MWAllButton = {
        var button = MWAllButton()
        button.isEnabled = false
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier)
        collectionView.contentInset.left = 16
        return collectionView
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 240)
        return layout
    }()

    // MARK: - initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .white
        self.selectionStyle = .none

        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.label)
        self.containerView.addSubview(self.button)
        self.containerView.addSubview(self.collectionView)

        self.setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCell(title: String, moives: [APIMovie]) {
        self.movies = moives
        self.title = title
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.containerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.label.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(32)
            make.left.equalToSuperview().inset(16)
            make.right.lessThanOrEqualTo(self.button.snp.left)
        }
        self.button.snp.updateConstraints { (make) in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalTo(label)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier, for: indexPath)
        (cell as? MWMainCollectionViewCell)?.initCell(movie: self.movies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deteilController = MWDetailsViewConroller()
        deteilController.initController(movieId: self.movies[indexPath.row].id)
        MWInterface.shared.pushVC(vc: deteilController)
    }
}
