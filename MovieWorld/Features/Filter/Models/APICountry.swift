//
//  APICountry.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 9/24/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

struct APICountry: Decodable {
    
    // MARK: - Variables
    let name: String
    let code: String
    
    // MARK: - Enum
    private enum CodingKeys: String, CodingKey {
        case code = "iso_3166_1"
        case name = "english_name"
    }
    
}
