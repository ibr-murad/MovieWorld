//
//  MWCastView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWCastView: UIView {
    // MARK: - variables
    private var movie: APIMovieDetails? {
        didSet {
            self.fetchCast()
        }
    }
    private var cast: [APIActor] = []
    
    // MARK: - gui variables
    private let sectionInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("cast", comment: "")
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: MWAllButton = {
        var button = MWAllButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWCastCollectionViewCell.self, forCellWithReuseIdentifier: MWCastCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 72, height: 120)
        return layout
    }()
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.newContentView)
        self.newContentView.addSubview(self.label)
        self.newContentView.addSubview(self.button)
        self.newContentView.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(movie: APIMovieDetails) {
        self.movie = movie
    }
    
    // MARK: - constraints
    override func updateConstraints() {
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.sectionInsets)
            make.height.equalTo(170)
        }
        self.label.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.lessThanOrEqualTo(self.button.snp.left)
        }
        self.button.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(8)
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(12)
            make.top.equalTo(self.button.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    private func fetchCast() {
        MWNetwork.shared.request(
            url: "movie/\(self.movie?.id ?? 481848)/credits",
            okHandler: { [weak self] (data: APICast, response) in
                guard let self = self else { return }
                self.cast = data.cast
                self.collectionView.reloadData()
        }) { (error, response) in
            print(error)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWCastView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MWCastCollectionViewCell.reuseIdentifier, for: indexPath) as? MWCastCollectionViewCell else { return UICollectionViewCell() }
        cell.actor = self.cast[indexPath.row]
        return cell
    }
}
