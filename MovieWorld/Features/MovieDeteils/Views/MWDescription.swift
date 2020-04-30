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
    // MARK: - gui variables
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Description"
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
        label.text = "A remake of the famous adventure movie of the 90s. A brother and sister come across a unique game. Hardly do they understand the danger of the game, as it doesn’t like cheat"
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
        self.makeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
    private func makeConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.qualityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview()
            make.right.equalTo(self.ageLabel.snp.left).offset(-16)
        }
        self.ageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.right.equalTo(self.timingLabel.snp.left).offset(-16)
        }
        self.timingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
        }
        self.descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.qualityLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}