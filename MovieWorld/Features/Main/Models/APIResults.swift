//
//  APIResults.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 2/27/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

struct APIResults: Decodable {
    // MARK: - variables
    let page: Int
    let numResults: Int
    let numPages: Int
    let movies: [APIMovie]
    
    // MARK: - enum
    private enum CodingKeys: String, CodingKey {
        case page,
        numResults = "total_results",
        numPages = "total_pages",
        movies = "results"
    }
}
