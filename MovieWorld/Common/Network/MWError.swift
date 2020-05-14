//
//  MWError.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/10/20.
//  Copyright © 2020 Murad. All rights reserved.
//

enum MWError: Error {
    case networkError(error: Error)
    case parsingError(error: Error)
    case serverError(statusCode: Int)
    case incorrectUrl(url: String)
    case other(info: String)
}
