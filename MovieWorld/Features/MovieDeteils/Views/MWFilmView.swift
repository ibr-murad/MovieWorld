//
//  MWFilmView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWFilmView: UIView {
    // MARK: - gui variables
    private lazy var videoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "video-image")
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var likeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "like-icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var dislikeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "dislike-icon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private lazy var likeLabel: UILabel = {
        var label = UILabel()
        label.text = "15K"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var dislikeLabel: UILabel = {
        var label = UILabel()
        label.text = "356"
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.videoImage)
        self.addSubview(self.likeImage)
        self.addSubview(self.likeLabel)
        self.addSubview(self.dislikeImage)
        self.addSubview(self.dislikeLabel)
        self.makeConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - constraints
    private func makeConstraints() {
        self.videoImage.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.likeImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.equalTo(self.likeLabel.snp.left).offset(-3)
            make.bottom.equalToSuperview()
        }
        self.likeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.equalTo(self.dislikeImage.snp.left).offset(-16)
            make.bottom.equalToSuperview()
        }
        self.dislikeImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.equalTo(self.dislikeLabel.snp.left).offset(-3)
            make.bottom.equalToSuperview()
        }
        self.dislikeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.bottom.equalToSuperview()
        }
    }
}
