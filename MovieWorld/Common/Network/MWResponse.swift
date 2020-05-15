//
//  MWResponse.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/15/20.
//  Copyright © 2020 Murad. All rights reserved.
//

enum MWResponse {
    case response(code: Int)
    
    func getMessage() -> String {
        var message = ""
        switch self {
        case .response(code: 200...299):
            message = "The request was successfully completed."
            break
        case .response(code: 400):
            message = "The request was invalid."
            break
        case .response(code: 401):
            message = "The request did not include an authentication token or the authentication token was expired."
            break
        case .response(code: 404):
            message = "The requested resource was not found."
            break
        case .response(code: 500):
            message = "The request was not completed due to an internal error on the server side."
            break
        case .response(code: 503):
            message = "The server was unavailable."
            break
        default:
            message = "Default"
        }
        return message
    }
}
