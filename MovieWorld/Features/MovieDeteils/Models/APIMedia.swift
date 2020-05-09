//
//  APIMedia.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIMedia: Decodable {
    // MARK: - variables
    let id: Int
    let results: [APIVideo]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, results
    }
}
