//
//  Movie.swift
//  MovieWorld
//
//  Created by Murad on 2/27/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMovie: Decodable {
    // MARK: - variables
    let id: Int
    let posterPath: String?
    let videoPath: String?
    let backdrop: String?
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
    let genres: [Int]

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        posterPath = "poster_path",
        videoPath,
        backdrop = "backdrop_path",
        title, releaseDate = "release_date",
        rating = "vote_average",
        overview,
        genres = "genre_ids"
    }
}
