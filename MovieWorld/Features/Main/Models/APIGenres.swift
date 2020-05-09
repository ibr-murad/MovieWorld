//
//  APIGenres.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/10/20.
//  Copyright © 2020 Murad. All rights reserved.
//

enum GenresListType: String {
    case tv, movie
}

struct APIGenres: Decodable {
    // MARK: - variables
    let genres: [APIGenre]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case genres
    }
}
