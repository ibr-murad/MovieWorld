//
//  MWDetailsViewConroller.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import SnapKit
import Kingfisher
import AVKit
import XCDYouTubeKit

class MWDetailsViewConroller: MWBaseViewController {
    // MARK: - gui variables
    var movie: APIMovie? {
        didSet {
            
        }
    }
    
    // MARK: - gui variables
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var cardView: MWCardView = {
        let view = MWCardView()
        view.movie = self.movie
        return view
    }()
    
    private lazy var filmView = MWFilmView()
    
    private lazy var descriptionView: MWDescription = {
        let view = MWDescription()
        view.movie = self.movie
        return view
    }()
    
    private lazy var castView: MWCastView = {
        let view = MWCastView()
        view.movie = self.movie
        return view
    }()
    
    private lazy var galleryView: MWGalleryView = {
        let view = MWGalleryView()
        view.movie = self.movie
        return view
    }()
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.filmView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.castView)
        self.scrollView.addSubview(self.galleryView)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playVideo),
                                               name: .presentPlayerViewController,
                                               object: nil)
        
        self.makeConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        }
        self.castView.snp.makeConstraints { (make) in
            make.top.equalTo(self.descriptionView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        self.galleryView.snp.makeConstraints { (make) in
            make.top.equalTo(self.castView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - setters
    private func setupController() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func playVideo(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true)
        
        MWNetwork.shared.request(url: "movie/\(self.movie?.id ?? 481848)/videos",
            okHandler: { (data: APIMedia, response) in
                let videoFromYoutube = data.results.first(where: { $0.site == "YouTube"} )
                XCDYouTubeClient.default().getVideoWithIdentifier(videoFromYoutube?.key) { (video, error) in
                    if let streamURL = video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] {
                        playerViewController.player = AVPlayer(url: streamURL)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }) { (error, response) in
            print(error)
        }
    }
}
