//
//  APIActor.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/8/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIActor: Decodable {
    // MARK: - variables
    let id: Int
    let character: String
    let name: String
    let photo: String?
    let creditId: String
    let gender: Int?
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        character,
        name,
        photo = "profile_path",
        creditId = "credit_id",
        gender
    }
}
