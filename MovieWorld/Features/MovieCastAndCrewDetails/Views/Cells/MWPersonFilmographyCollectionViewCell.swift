//
//  MWPersonFilmographyCollectionViewCell.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import Kingfisher

class MWPersonFilmographyCollectionViewCell: UICollectionViewCell {
    // MARK: - variables
    static let reuseIdentifier = "MWPersonFilmographyCollectionViewCell"
    private var movie: APIMovieCreditsCast? {
        didSet{
            self.setup()
        }
    }

    // MARK: - gui variables
    private lazy var image: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "movie")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()

    private lazy var title: UILabel = {
        var title = UILabel()
        title.text = "21 Bridges"
        title.font = .boldSystemFont(ofSize: 17)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private lazy var subTitle: UILabel = {
        var subTitle = UILabel()
        subTitle.text = "2019, Drama"
        subTitle.font = .systemFont(ofSize: 13)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        return subTitle
    }()

    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.image)
        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.subTitle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(movie: APIMovieCreditsCast) {
        self.movie = movie
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.image.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 130, height: 185))
        }
        self.title.snp.updateConstraints { (make) in
            make.top.equalTo(self.image.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        self.subTitle.snp.updateConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    // MARK: - setters
    func setup() {
        guard let movie = self.movie else { return }
        if let photo = movie.posterPath {
            guard let imageURL = URL(string: (BaseUrl.poster + photo)) else { return }
            self.image.kf.indicatorType = .activity
            self.image.kf.setImage(
                with: imageURL,
                placeholder: .none,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        self.title.text = movie.title
        self.subTitle.text = String(movie.releaseDate.prefix(4))

        self.setNeedsUpdateConstraints()
    }
}
