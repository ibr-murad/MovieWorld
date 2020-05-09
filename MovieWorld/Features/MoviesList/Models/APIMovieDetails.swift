//
//  APIMovieDetails.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMovieDetails: Decodable {
    // MARK: - variables
    let id: Int
    let posterPath: String?
    let backdrop: String?
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
    let genres: [APIGenre]
    let runtime: Int?
    let adult: Bool
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        posterPath = "poster_path",
        backdrop = "backdrop_path",
        title, releaseDate = "release_date",
        rating = "vote_average",
        overview,
        genres,
        runtime,
        adult
    }
}
