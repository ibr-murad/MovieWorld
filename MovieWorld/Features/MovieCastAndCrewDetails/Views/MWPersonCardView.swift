//
//  MWPersonCardView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWPersonCardView: UIView {
    // MARK: - gui variables
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
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.addShadow()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let imageInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    private lazy var profileImageView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        return image
    }()

    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.text = "Name Name "
        label.font = .boldSystemFont(ofSize: 17)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var characterLabel: UILabel = {
        var label = UILabel()
        label.text = "Character Character"
        label.font = .systemFont(ofSize: 13)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateOfBirthLabel: UILabel = {
        var label = UILabel()
        label.text = "01.03.1978 to date (40 years)"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.alpha = 0.5
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .none

        self.addSubview(self.newContentView)
        self.newContentView.addSubview(self.profileImageView)
        self.newContentView.addSubview(self.nameLabel)
        self.newContentView.addSubview(self.characterLabel)
        self.newContentView.addSubview(self.dateOfBirthLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(personId: Int) {
        self.personId = personId
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.profileImageView.snp.updateConstraints { (make) in
            make.top.left.bottom.equalToSuperview().inset(self.imageInsets)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        self.nameLabel.snp.updateConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo(self.profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        self.characterLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            make.left.equalTo(self.profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }
        self.dateOfBirthLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.characterLabel.snp.bottom).offset(1)
            make.left.equalTo(self.profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(4)
        }

        super.updateConstraints()
    }

    // MARK: - setters
    func setup() {
        guard let actor = self.person else { return }
        if let photo = actor.photo {
            guard let imageURL = URL(string: (BaseUrl.profile + photo)) else { return }
            self.profileImageView.kf.indicatorType = .activity
            self.profileImageView.kf.setImage(
                with: imageURL,
                placeholder: .none,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        self.nameLabel.text = actor.name
        self.characterLabel.text = actor.placeOfBirth
        if let birthday = actor.birthday {
            self.dateOfBirthLabel.text = self.calculateAge(birthday: birthday)
        }

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

    // MARK: - utility
    private func calculateAge(birthday: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: birthday)
        guard let newDate = date else { return "No date"}
        let ageComponents = Calendar.current.dateComponents([.year, .month, .day], from: newDate, to: Date())
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return "\(dateFormatter.string(from: newDate)) (\(ageComponents.year ?? 0) years)"
    }
}
