//
//  MWDetailsViewConroller.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/26/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import SnapKit
import AVKit
import XCDYouTubeKit

class MWDetailsViewConroller: MWBaseViewController {
    // MARK: - gui variables
    private var movieId = 0 {
        didSet {
            self.requestForMovieDetails()
        }
    }
    var movie: APIMovieDetails?

    // MARK: - gui variables
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private lazy var cardView: MWCardView = {
        let view = MWCardView()
        if let movie = self.movie {
            view.initView(movie: movie)
        }
        return view
    }()

    private lazy var filmView: MWFilmView = {
        let view = MWFilmView()
        if let movie = self.movie {
            view.initView(movie: movie)
        }
        return view
    }()

    private lazy var descriptionView: MWDescription = {
        let view = MWDescription()
        if let movie = self.movie {
            view.initView(movie: movie)
        }
        return view
    }()

    private lazy var castView: MWCastView = {
        let view = MWCastView()
        if let movie = self.movie {
            view.initView(movie: movie)
        }
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.allCastTapped)))
        return view
    }()

    private lazy var galleryView: MWGalleryView = {
        let view = MWGalleryView()
        if let movie = self.movie {
            view.initView(movie: movie)
        }
        return view
    }()

    // MARK: - initialization
    func initController(movieId: Int) {
        self.movieId = movieId
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

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.playVideo),
                                               name: .presentPlayerViewController,
                                               object: nil)
        //self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    // MARK: - setters
    private func setupController() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.filmView)
        self.scrollView.addSubview(self.descriptionView)
        self.scrollView.addSubview(self.castView)
        self.scrollView.addSubview(self.galleryView)
        self.makeConstraints()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - requests
    private func requestForMovieDetails() {
        let group = DispatchGroup()
        group.enter()
        MWNetwork.shared.request(url: "movie/\(self.movieId)",
            okHandler: { [weak self] (data: APIMovieDetails, response) in
                guard let self = self else { return }
                self.movie = data
                group.leave()
        }) { (error, response) in
            print(error)
            group.leave()
        }

        group.notify(queue: .main) {
            self.setupController()
        }
    }

    // MARK: - actions
    @objc func allCastTapped(_ tapGestureRecognizer: UITapGestureRecognizer) {
        /*let castAndCrewViewController = MWMovieCastAndCrewViewController()
        castAndCrewViewController.initController(movieId: self.movie?.id ?? 0)
        MWInterface.shared.pushVC(vc: castAndCrewViewController)*/
        
        let controller = MWCastAndCrewViewController()
        controller.initController(movieId: self.movie?.id ?? 0)
        MWInterface.shared.pushVC(vc: controller)
    }
    
    @objc func playVideo(_ tapGestureRecognizer: UITapGestureRecognizer) {
        let avPlayer = AVPlayerViewController()
        avPlayer.showsPlaybackControls = true
        avPlayer.view.frame = self.view.frame
        print(self.view.frame)
        self.present(avPlayer, animated: true)
        
        XCDYouTubeClient.default().getVideoWithIdentifier("01ON04GCwKs") { [weak avPlayer] (video, error) in
            if let video = video, let avPlayer = avPlayer {
                let streamURL = video.streamURLs
                let fullURL = streamURL[XCDYouTubeVideoQuality.HD720.rawValue]
                    ?? streamURL[XCDYouTubeVideoQuality.medium360.rawValue]
                    ?? streamURL[XCDYouTubeVideoQuality.small240.rawValue]
                
                if let fullURL = fullURL {
                    print(fullURL)
                    let assetUrl = AVURLAsset(url: fullURL)
                    let item = AVPlayerItem(asset: assetUrl)
                    let player = AVPlayer(playerItem: item)
                    avPlayer.player = player
                    avPlayer.player?.play()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        //01ON04GCwKs
        /*let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true)
        
        MWNetwork.shared.request(url: "movie/\(self.movie?.id ?? 0)/videos",
            
            okHandler: { [weak self] (data: APIMedia, response) in
                guard let self = self else { return }
                let videoFromYoutube = data.results.first(where: { $0.site == "YouTube"} )
                guard let id = videoFromYoutube?.key else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                XCDYouTubeClient.default().getVideoWithIdentifier(id) { (video, error) in
                    print(id)
                    //if let streamURL = video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] {
                    if let streamURL = video?.streamURLs[XCDYouTubeVideoQuality.medium360.rawValue] {
                        print(streamURL)
                        playerViewController.player = AVPlayer(url: streamURL)
                        playerViewController.player?.play()
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }) { (error, response) in
            print(error)
        }*/
    }
}
