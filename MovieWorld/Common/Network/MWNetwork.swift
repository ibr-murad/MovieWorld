//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Murad on 3/2/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

class MWNetwork {
    // MARK: - variables
    static let shared = MWNetwork()
    private var session = URLSession.init(configuration: .default)
    private let baseUrl: String = "https://api.themoviedb.org/3/"
    public static let imageBaseUrl: String = "https://image.tmdb.org/t/p/w200"
    private let api_key: String = "79d5894567be5b76ab7434fc12879584"
    private var params: [String: String] = [:]
    // MARK: - initialization
    private init() {
        params["api_key"] = self.api_key
    }
    // MARK: - request
    func request<T: Decodable>(url: String,
                               params: [String: String]? = nil,
                               okHandler: @escaping (_ data: T, _ response: HTTPURLResponse?) -> Void,
                               errorHandler: @escaping (_ error: MWError, _ response: HTTPURLResponse?) -> Void) {
        var fullPath = self.baseUrl + url
        fullPath = self.getUrlWithParams(fullPath: fullPath, params: self.params)
        guard let url = URL(string: fullPath) else { return }
        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else { return }
                if error != nil {
                    errorHandler(.serverError(statusCode: response.statusCode ), response)
                    return
                }
                guard let data = data else { return }
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    okHandler(result, response)
                } else {
                    if let error = error {
                        errorHandler(.parsingError(error: error ), response)
                    }
                    return
                }
            }
        }.resume()
    }
}

struct URLPath {
    static let popular = "movie/popular"
    static let upcoming = "movie/upcoming"
    static let topRated = "movie/top_rated"
    static let nowPlaing = "movie/now_playing"
    static let genreTvList = "genre/tv/list"
    static let genreMovieList = "genre/movie/list"
}
