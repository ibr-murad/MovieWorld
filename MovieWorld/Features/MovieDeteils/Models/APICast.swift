//
//  APICast.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/8/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APICast: Decodable {
    // MARK: - variables
    let id: Int
    let cast: [APIActor]
    let crew: [APICredit]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id, cast, crew
    }
}
