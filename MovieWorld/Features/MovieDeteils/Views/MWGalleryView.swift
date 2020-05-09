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
    var movie: APIMovie?
    private var gallery: [APIImage] = []
    private let sectionInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
    
    // MARK: - gui variables
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "Trailers and gallery"
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
        
        self.fetchCast()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func fetchCast() {
        let group = DispatchGroup()
        group.enter()
        MWNetwork.shared.request(url: "movie/\(self.movie?.id ?? 481848)/images",
            okHandler: { (data: APIGallery, response) in
                self.gallery = data.backdrops
                group.leave()
        }) { (error, response) in
            print(error)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWGalleryView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MWGalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? MWGalleryCollectionViewCell else { return UICollectionViewCell() }
        cell.imageFormApi = self.gallery[indexPath.row]
        return cell
    }
}
