//
//  Movie.swift
//  MovieWorld
//
//  Created by Murad on 2/27/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMovie: Codable {
    // MARK: - variables
    let id: Int
    let posterPath: String?
    let backdrop: String?
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
    let genres: [Int]

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        title,
        overview,
        posterPath = "poster_path",
        backdrop = "backdrop_path",
        releaseDate = "release_date",
        rating = "vote_average",
        genres = "genre_ids"
    }
}
