//
//  MWMovieCastAndCrewDetailsViewController.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWMovieCastAndCrewDetailsViewController: MWBaseViewController {
    
    // MARK: - variables
    private var personId: Int = 0 
    
    // MARK: - gui variables
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var cardView: MWPersonCardView = {
        let view = MWPersonCardView()
        view.initView(personId: self.personId)
        return view
    }()
    
    private lazy var filmographyView: MWPersonFilmographyView = {
        let view = MWPersonFilmographyView()
        view.initView(personId: personId)
        return view
    }()
    
    private lazy var descriptionView: MWPersonDescription = {
        let view = MWPersonDescription()
        view.initView(personId: self.personId)
        return view
    }()
    
    // MARK: - initialization
    func initController(personId: Int) {
        self.personId = personId
    }
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - constraints
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).inset(10)
            make.left.right.bottom.equalToSuperview()
        }
        self.cardView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(self.view.snp.width)
        }
        self.filmographyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cardView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.filmographyView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - setters
    private func setupController() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.filmographyView)
        self.scrollView.addSubview(self.descriptionView)
        
        self.makeConstraints()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}
