//
//  APIMovieCreditsCrew.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMovieCreditsCrew: Decodable {
    // MARK: - variables
    let id: Int
    let posterPath: String?
    let backdrop: String?
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
    let genres: [Int]
    let department: String
    let job: String

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        posterPath = "poster_path",
        backdrop = "backdrop_path",
        title,
        releaseDate = "release_date",
        rating = "vote_average",
        overview,
        genres = "genre_ids",
        department,
        job
    }
}
