//
//  MWAllMoviesTableViewCell.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/17/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MWMoviesListTableViewCell: UITableViewCell {
    // MARK: - variables
    static let reuseIdentifier = "allMoviesTableCell"
    var genres = [Genre]()
    public var movie: APIMovie? {
        didSet {
            self.setup()
        }
    }
    let ids = [28, 35, 99, 10751]
    // MARK: - gui variables
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var posterImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "movie")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "21 Briges"
        label.font = .boldSystemFont(ofSize: 17)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var yearCountryLabel: UILabel = {
        var label = UILabel()
        label.text = "2019, USA"
        label.font = .systemFont(ofSize: 13)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var genresLabel: UILabel = {
        var label = UILabel()
        label.text = "Drama, Foreing Drama, Foreing Drama, Foreing Drama, Foreing Drama, Foreing"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.alpha = 0.5
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var ratingLabel: UILabel = {
        var label = UILabel()
        label.text = "IMDB 8.2, KP 8.3"
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    // MARK: - initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.newContentView)
        self.newContentView.addSubview(self.posterImageView)
        self.newContentView.addSubview(self.nameLabel)
        self.newContentView.addSubview(self.yearCountryLabel)
        self.newContentView.addSubview(self.genresLabel)
        self.newContentView.addSubview(self.ratingLabel)
        /*var text = ""
        for i in ids {
            if let foundedGenre =  genres.first(where: {$0.id == i} ) {
                text += "\(foundedGenre.name), "
            }
        }*/
        self.updateConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
    override func updateConstraints() {
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.posterImageView.snp.updateConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(16)
        }
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.posterImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        self.yearCountryLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            make.left.equalTo(self.posterImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        self.genresLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.yearCountryLabel.snp.bottom).offset(1)
            make.left.equalTo(self.posterImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        self.ratingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.genresLabel.snp.bottom).offset(8)
            make.left.equalTo(self.posterImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        super.updateConstraints()
    }
    // MARK: - setters / helpers / actions / handlers / utility
    public func setup() {
        guard let movie = self.movie else { return }
        guard let imageURL = URL(string: (MWNetwork.imageBaseUrl + movie.posterPath)) else { return }
        self.posterImageView.kf.indicatorType = .activity
        self.posterImageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        self.nameLabel.text = movie.title
        self.yearCountryLabel.text = String(movie.releaseDate.prefix(4))
        self.genresLabel.text = "\(movie.genres)"
        self.ratingLabel.text = "\(movie.rating)"
    }
}
