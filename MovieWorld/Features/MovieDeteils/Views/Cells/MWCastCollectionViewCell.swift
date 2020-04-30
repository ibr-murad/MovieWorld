//
//  MWCastCollectionViewCell.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import Kingfisher

class MWCastCollectionViewCell: UICollectionViewCell {
    // MARK: - variables
    static let reuseIdentifier = "castCollectionCell"
    private var genres = [Genre]()
    public var movie: APIMovie? {
        didSet {
            self.setup()
        }
    }
    // MARK: - gui variables
    private lazy var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "apiMovie")
        image.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    private lazy var title: UILabel = {
        var title = UILabel()
        title.text = "21 Briges"
        title.font = .boldSystemFont(ofSize: 17)
        title.setContentHuggingPriority(.defaultHigh, for: .vertical)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    private lazy var subTitle: UILabel = {
        var subTitle = UILabel()
        subTitle.text = "2019, Drama"
        subTitle.font = .systemFont(ofSize: 13)
        subTitle.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        return subTitle
    }()
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subTitle)
        self.image.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.title.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.image.snp.bottom).offset(12)
        }
        self.subTitle.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.title.snp.bottom)
        }
        //self.updateConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
   /*override func updateConstraints() {
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
    }*/
    // MARK: - setters / helpers / actions / handlers / utility
    public func setup() {
        guard let movie = self.movie else { return }
        guard let imageURL = URL(string: (MWNetwork.imageBaseUrl + movie.posterPath)) else { return }
        self.image.kf.indicatorType = .activity
        self.image.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        self.title.text = movie.title
        var subTitleString = String(movie.releaseDate.prefix(4)) //year
        if let firstGenre =  genres.first(where: {$0.id == movie.genres[0]} ) {
            subTitleString += ", \(firstGenre.name)"
        }
        self.subTitle.text = subTitleString
    }
}
