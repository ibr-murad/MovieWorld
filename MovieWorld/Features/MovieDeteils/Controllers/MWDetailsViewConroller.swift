//
//  MWDetailsViewConroller.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import SnapKit
import Kingfisher

class MWDetailsViewConroller: UIViewController {
    // MARK: - gui variables
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    private lazy var cardView = MWCardView()
    private lazy var filmView = MWFilmView()
    private lazy var descriptionView = MWDescription()
    private lazy var castView = MWCastView()
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.filmView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.castView)
        self.makeConstraints()
    }
    // MARK: - constraints
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(13)
            make.left.right.bottom.equalToSuperview()
        }
        self.cardView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
        }
        self.filmView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardView.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(16)
        }
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.filmView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            //make.bottom.equalToSuperview()
        }
        self.castView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()//.inset(16)
        }
    }
    // MARK: - setters / helpers / actions / handlers / utility
    private func setupController() {
        self.view.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "accentColor")
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
