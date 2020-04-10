//
//  Movie.swift
//  MovieWorld
//
//  Created by Murad on 2/27/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

struct Movie {
    
    let id: Int!
    let posterPath: String
    var videoPath: String?
    let backdrop: String
    let title: String
    var releaseDate: String
    var rating: Double
    let overview: String
}

extension Movie: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, posterPath = "poster_path", videoPath, backdrop = "backdrop_path", title, releaseDate = "release_date", rating = "vote_average", overview
    }
}
