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
    // MARK: - variables
    private var movie: APIMovieDetails? {
        didSet {
            self.setup()
        }
    }

    // MARK: - gui variables
    private lazy var videoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "videoImage")
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(self.playImageTapped)))
        return image
    }()

    private lazy var playImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "playIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var likeImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "likeIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var likeLabel: UILabel = {
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
        self.videoImage.addSubview(self.playImage)
        self.addSubview(self.likeImage)
        self.addSubview(self.likeLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(movie: APIMovieDetails) {
        self.movie = movie
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.videoImage.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.playImage.snp.updateConstraints { (make) in
            make.center.equalToSuperview()
        }
        self.likeImage.snp.updateConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.equalTo(self.likeLabel.snp.left).offset(-3)
            make.bottom.equalToSuperview()
        }
        self.likeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.videoImage.snp.bottom).offset(16)
            make.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    // MARK: - setters
    private func setup() {
        guard let movie = self.movie else { return }
        guard let imageURL = URL(string: (BaseUrl.backdrop + (movie.backdrop ?? "" ))) else { return }
        self.videoImage.kf.indicatorType = .activity
        self.videoImage.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        self.likeLabel.text = String(movie.voteCount)

        self.setNeedsUpdateConstraints()
    }

    // MARK: - actions
    @objc func playImageTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .presentPlayerViewController, object: nil)
    }
}
