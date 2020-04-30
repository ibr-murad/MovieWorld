//
//  MWCardView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWCardView: UIView {
    // MARK: - gui variables
    private lazy var posterImageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "movie")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.posterImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.yearCountryLabel)
        self.addSubview(self.genresLabel)
        self.addSubview(self.ratingLabel)
        self.makeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
    private func makeConstraints() {
        self.posterImageView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(32)
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
    }
}
