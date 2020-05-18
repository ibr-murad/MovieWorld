//
//  MWPersonDescription.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWPersonDescription: UIView {
    // MARK: - variables
    private var personId: Int = 0 {
        didSet {
            self.requestForPersonDetail()
        }
    }
    private var person: APIPerson? {
        didSet {
            self.setup()
        }
    }

    // MARK: - gui variables
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("biography", comment: "")
        label.font = .boldSystemFont(ofSize: 17)
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
        self.addSubview(self.descriptionLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        self.descriptionLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    func initView(personId: Int) {
        self.personId = personId
    }

    // MARK: - setters
    private func setup() {
        self.descriptionLabel.text = self.person?.biography
        self.setNeedsUpdateConstraints()
    }

    // MARK: - request
    private func requestForPersonDetail() {
        MWNetwork.shared.request(url: "person/\(self.personId)",
            okHandler: { [weak self] (data: APIPerson, response) in
                guard let self = self else { return }
                self.person = data
        }) { (error, response) in
            print(error)
        }
    }
}
