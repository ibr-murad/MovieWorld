//
//  MWMoviesListCollectionViewCell.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/20/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWMoviesListCollectionViewCell: UICollectionViewCell {
    // MARK: - variables
    static let reuseIdentifier = "MWMoviesListCollectionViewCell"
    
    // MARK: - gui variables
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "accentColor")
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.contentView.addSubview(self.conteinerView)
        self.conteinerView.addSubview(self.categoryLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - constraints
    override func updateConstraints() {
        self.conteinerView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.categoryLabel.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(5)
        }
        super.updateConstraints()
    }
    
    // MARK: - setters
    func setCategory(_ category: String) {
        self.categoryLabel.text = category
        self.setNeedsUpdateConstraints()
    }
}
