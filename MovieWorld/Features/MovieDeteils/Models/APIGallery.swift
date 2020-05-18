//
//  APIGallery.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIGallery: Decodable {
    // MARK: - variables
    let id: Int
    let backdrops: [APIImage]
    let posters: [APIImage]

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, backdrops, posters
    }
}
