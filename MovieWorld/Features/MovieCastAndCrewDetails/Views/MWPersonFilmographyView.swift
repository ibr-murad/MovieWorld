//
//  MWPersonFilmographyView.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit
import SnapKit

class MWPersonFilmographyView: UIView {
    // MARK: - variables
    private var isActor: Bool = true
    private var personId: Int = 0 {
        didSet {
            self.requestForPersonFilmography()
        }
    }
    private var movies: [APIMovieCreditsCast] = []

    // MARK: - gui variables
    private let sectionInsets = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
    private lazy var newContentView: UIView = {
        var view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("filmography", comment: "")
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MWPersonFilmographyCollectionViewCell.self,
                                forCellWithReuseIdentifier: MWPersonFilmographyCollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 225)
        return layout
    }()

    // MARK: - initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.newContentView)
        self.newContentView.addSubview(self.label)
        self.newContentView.addSubview(self.collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(personId: Int) {
        self.personId = personId
    }

    // MARK: - constraints
    override func updateConstraints() {
        self.newContentView.snp.updateConstraints { (make) in
            make.edges.equalToSuperview().inset(self.sectionInsets)
            make.height.equalTo(280)
        }
        self.label.snp.updateConstraints { (make) in
            make.top.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        self.collectionView.snp.updateConstraints { (make) in
            make.top.equalTo(self.label.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }

        super.updateConstraints()
    }

    private func requestForPersonFilmography() {
        MWNetwork.shared.request(url: "person/\(self.personId)/movie_credits",
            okHandler: { [weak self] (data: APIMovieCredits, response) in
                guard let self = self else { return }
                self.movies = data.cast
                if self.movies.count < 3 && data.crew.count != 0 {
                    self.mergeArrays(crews: data.crew)
                }
                self.collectionView.reloadData()
        }) { (error, response) in
            print(error)
        }
    }

    private func mergeArrays(crews: [APIMovieCreditsCrew]) {
        for movie in crews {
            self.movies.append(
                APIMovieCreditsCast(id: movie.id,
                                    posterPath: movie.posterPath,
                                    backdrop: movie.backdrop,
                                    title: movie.title,
                                    releaseDate: movie.releaseDate,
                                    rating: movie.rating,
                                    overview: movie.overview,
                                    genres: movie.genres,
                                    character: movie.job))
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MWPersonFilmographyView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MWPersonFilmographyCollectionViewCell.reuseIdentifier,
            for: indexPath)
        (cell as? MWPersonFilmographyCollectionViewCell)?.initView(movie: self.movies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let deteilController = MWDetailsViewConroller()
        deteilController.initController(movieId: self.movies[indexPath.row].id)
        MWInterface.shared.pushVC(vc: deteilController)
    }
}
