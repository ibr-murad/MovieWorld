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
    private let sectionInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
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
        collectionView.register(MWMainCollectionViewCell.self, forCellWithReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 225)
        return layout
    }()
    
    // MARK: - initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.newContentView)
        self.newContentView.addSubview(self.label)
        self.newContentView.addSubview(self.button)
        self.newContentView.addSubview(self.collectionView)
        
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
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.sectionInsets)
        }
        self.label.snp.updateConstraints { (make) in
            make.left.top.equalToSuperview()
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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWMainTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: MWMainCollectionViewCell.reuseIdentifier, for: indexPath) as? MWMainCollectionViewCell else { return UICollectionViewCell() }
        cell.initCell(movie: self.movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deteilController = MWDetailsViewConroller()
        deteilController.initController(movieId: self.movies[indexPath.row].id)
        MWInterface.shared.pushVC(vc: deteilController)
    }
}
