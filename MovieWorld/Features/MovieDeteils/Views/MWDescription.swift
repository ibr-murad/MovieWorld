//
//  MWDescription.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/30/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWDescription: UIView {
    // MARK: - variables
    private var movie: APIMovieDetails? {
        didSet {
            self.setup()
        }
    }

    // MARK: - gui variables
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("description", comment: "")
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var qualityLabel: UILabel = {
        var label = UILabel()
        label.text = "HD"
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ageLabel: UILabel = {
        var label = UILabel()
        label.text = "16+"
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timingLabel: UILabel = {
        var label = UILabel()
        label.text = "116 minutes"
        label.alpha = 0.5
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "danger of the game, as it doesn’t like cheat"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.titleLabel)
        self.addSubview(self.qualityLabel)
        self.addSubview(self.ageLabel)
        self.addSubview(self.timingLabel)
        self.addSubview(self.descriptionLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(movie: APIMovieDetails) {
        self.movie = movie
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.qualityLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalTo(self.ageLabel.snp.left).offset(-16)
        }
        self.ageLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.right.equalTo(self.timingLabel.snp.left).offset(-16)
        }
        self.timingLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.qualityLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    // MARK: - setters
    private func setup() {
        self.descriptionLabel.text = self.movie?.overview
        if self.movie?.adult ?? false {
            self.ageLabel.text = "18+"
        } else {
            self.ageLabel.text = "12+"
        }
        self.timingLabel.text = "\(self.movie?.runtime ?? 0)"

        self.setNeedsUpdateConstraints()
    }
}
