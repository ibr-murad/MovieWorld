//
//  APICredit.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/12/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APICredit: Decodable {
    // MARK: - variables
    let id: Int
    let department: String
    let name: String
    let photo: String?
    let creditId: String
    let gender: Int?
    let job: String
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case id,
        department,
        name,
        photo = "profile_path",
        creditId = "credit_id",
        gender,
        job
    }
}
