//
//  APIImage.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIImage: Decodable {
    // MARK: - variables
    let path: String
    let height: Int
    let width: Int

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case path = "file_path", height, width
    }
}
