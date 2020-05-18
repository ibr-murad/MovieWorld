//
//  MWGalleryView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/8/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWGalleryView: UIView {
    // MARK: - variables
    private var movie: APIMovieDetails? {
        didSet {
            self.fetchGallery()
        }
    }
    private var gallery: [APIImage] = []

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
        label.text = NSLocalizedString("gallery", comment: "")
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWGalleryCollectionViewCell.self, forCellWithReuseIdentifier: MWGalleryCollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 87)
        return layout
    }()

    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.newContentView)
        self.newContentView.addSubview(self.label)
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
            make.height.equalTo(130)
        }
        self.label.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    private func fetchGallery() {
        MWNetwork.shared.request(
            url: "movie/\(self.movie?.id ?? 481848)/images",
            okHandler: { [weak self] (data: APIGallery, response) in
                guard let self = self else { return }
                if data.backdrops.count != 0 {
                    self.gallery = data.backdrops
                } else if data.posters.count != 0 {
                    self.gallery = data.posters
                }
                self.collectionView.reloadData()
        }) { (error, response) in
            print(error)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallery.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWGalleryCollectionViewCell.reuseIdentifier,
                                                     for: indexPath)
        (cell as? MWGalleryCollectionViewCell)?.initView(image: self.gallery[indexPath.row])
        return cell
    }
}
