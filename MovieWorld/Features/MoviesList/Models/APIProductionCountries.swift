//
//  APIProductionCountries.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/9/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIProductionCountries: Decodable {
    // MARK: - variables
    let iso: String
    let name: String

    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1", name
    }
}
