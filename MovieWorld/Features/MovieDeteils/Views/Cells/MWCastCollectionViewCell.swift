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
    static let reuseIdentifier = "MWCastCollectionViewCell"
    private var genres: [Genre] = []
    private var actor: APIActor? {
        didSet{
            self.setup()
        }
    }

    // MARK: - gui variables
    private lazy var image: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()

    private lazy var title: UILabel = {
        var title = UILabel()
        title.text = "Dwayne"
        title.font = .boldSystemFont(ofSize: 17)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()

    private lazy var subTitle: UILabel = {
        var subTitle = UILabel()
        subTitle.text = "Johnson"
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

    func initView(actor: APIActor) {
        self.actor = actor
    }

    // MARK: - constraints
   override func updateConstraints() {
        self.image.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 72, height: 72))
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
        guard let actor = self.actor else { return }
        if let photo = actor.photo {
            guard let imageURL = URL(string: (BaseUrl.profile + photo)) else { return }
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

        let indexOfSpaceInName = actor.name.firstIndex(of: " ")
        let indexOfSpaceInCharacter = actor.character.firstIndex(of: " ")
        if let indexName = indexOfSpaceInName, let indexCharacter = indexOfSpaceInCharacter {
            self.title.text = String(actor.name.prefix(upTo: indexName))
            self.subTitle.text = String(actor.character.prefix(upTo: indexCharacter))
        } else {
            self.title.text = actor.name
            self.subTitle.text = actor.character
        }

        self.setNeedsUpdateConstraints()
    }
}
