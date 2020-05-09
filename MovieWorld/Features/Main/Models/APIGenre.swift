//
//  APIGenre.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/6/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIGenre: Decodable {
    // MARK: - variables
    let id: Int
    let name: String
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}
