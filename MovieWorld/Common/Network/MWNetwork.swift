//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Murad on 3/2/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

class MWNetwork {
    
    static let shared = MWNetwork()
    private var session = URLSession.init(configuration: .default)
    private let baseUrl: String = "https://api.themoviedb.org/3/movie/"
    public static let imageBaseUrl: String = "https://image.tmdb.org/t/p/w200"
    private let api_key: String = "79d5894567be5b76ab7434fc12879584"
    private var params: [String: String] = [:]
    
    private init() {
        params["api_key"] = self.api_key
    }
    
    func request(url: String,
                 params: [String: String]? = nil,
                 okHandler: @escaping (_ data: APIResults,_ response: URLResponse?) -> Void,
                 errorHandler: @escaping (_ error: Errors,_ response: URLResponse?) -> Void
                 ) {
        
        var fullPath = self.baseUrl + url
        
        fullPath = self.getUrlWithParams(fullPath: fullPath, params: self.params)
        guard let url = URL(string: fullPath) else { return }
        
        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("some error")
                    errorHandler(.other, response)
                    return
                }
                guard let data = data else { return }
                if let result = try? JSONDecoder().decode(APIResults.self, from: data) {
                    okHandler(result, response)
                } else {
                    errorHandler(.parsing, response)
                    return
                }
            }
        }.resume()
    }
}

struct URLPath {
    static let popular = "popular"
    static let upcoming = "upcoming"
    static let topRated = "top_rated"
}

enum Errors: Error {
    case parsing
    case unknow
    case other
}
