//
//  MWGalleryCollectionViewCell.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/8/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import Kingfisher

class MWGalleryCollectionViewCell: UICollectionViewCell {
    // MARK: - variables
    static let reuseIdentifier = "MWGalleryCollectionViewCell"
    var imageFormApi: APIImage? {
        didSet{
            self.setup()
        }
    }
    
    // MARK: - gui variables
    private lazy var imageView: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "videoImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imageView)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    override func updateConstraints() {
        self.imageView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    // MARK: - setters
    private func setup() {
        guard let image = self.imageFormApi else { return }
        guard let imageURL = URL(string: (BaseUrl.backdrop + image.path)) else { return }
        self.imageView.kf.indicatorType = .activity
        self.imageView.kf.setImage(
            with: imageURL,
            placeholder: .none,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        self.setNeedsUpdateConstraints()
    }
}
