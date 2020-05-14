//
//  APIActorDatail.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/12/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIPerson: Decodable {
    // MARK: - variables
    let id: Int
    let name: String
    let birthday: String?
    let deathday: String?
    let photo: String?
    let biography: String
    let popularity: Double
    let placeOfBirth: String?
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        name,
        birthday,
        deathday,
        photo = "profile_path",
        biography,
        popularity,
        placeOfBirth = "place_of_birth"
    }
}
