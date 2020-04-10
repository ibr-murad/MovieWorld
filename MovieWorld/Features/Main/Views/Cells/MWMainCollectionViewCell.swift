//
//  MWMainCollectionViewCell.swift
//  MovieWorld
//
//  Created by Murad on 2/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

class MWMainCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "mainCollectionCell"
    public var movie: Movie? {
        didSet {
            self.setup()
        }
    }
    
    private lazy var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "movie")
        image.setContentCompressionResistancePriority(.init(250), for: .vertical)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var title: UILabel = {
        var title = UILabel()
        title.text = "21 Briges"
        title.font = .boldSystemFont(ofSize: 17)
        title.setContentHuggingPriority(.init(1000), for: .vertical)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var subTitle: UILabel = {
        var subTitle = UILabel()
        subTitle.text = "2019, Drama"
        subTitle.font = .systemFont(ofSize: 13)
        subTitle.setContentHuggingPriority(.init(1000), for: .vertical)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        return subTitle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subTitle)
        
        self.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        self.image.snp.updateConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.title.snp.updateConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.image.snp.bottom).offset(12)
        }
        self.subTitle.snp.updateConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.title.snp.bottom)
        }
        super.updateConstraints()
    }
    
    public func setup() {
        if let posterPath = self.movie?.posterPath {
            guard let imageURL = URL(string: (MWNetwork.imageBaseUrl + posterPath)) else { return }
            guard let resource = try? Data(contentsOf: imageURL) else { return }
            self.image.image = UIImage(data: resource)
        }
        
        self.title.text = self.movie?.title
        self.subTitle.text = self.movie?.releaseDate
    }
}
