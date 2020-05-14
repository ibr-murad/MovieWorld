//
//  APIMovieCredits.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/14/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMovieCredits: Decodable {
    // MARK: - variables
    let id: Int
    let cast: [APIMovieCreditsCast]
    let crew: [APIMovieCreditsCrew]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, cast, crew
    }
}
