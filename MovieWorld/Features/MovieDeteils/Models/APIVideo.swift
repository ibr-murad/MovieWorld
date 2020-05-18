//
//  APIVideo.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIVideo: Decodable {
    // MARK: - variables
    let id: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, key, name, site, size, type
    }
}
