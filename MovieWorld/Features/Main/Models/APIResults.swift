//
//  APIResults.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 2/27/20.
//  Copyright © 2020 Murad. All rights reserved.
//

struct APIResults: Decodable {
    // MARK: - variables
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let movies: [APIMovie]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case page,
        totalResults = "total_results",
        totalPages = "total_pages",
        movies = "results"
    }
}
