//
//  APIGenres.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/10/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

public enum GenresListType: String{
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

struct APIGenre: Decodable {
    // MARK: - variables
    let id: Int
    let name: String
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}
