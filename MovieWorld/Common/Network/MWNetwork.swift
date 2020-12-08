//
//  MWNetwork.swift
//  MovieWorld
//
//  Created by Murad on 3/2/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

typealias Success<T> = (_ data: T, _ response: MWResponse) -> Void
typealias Failure = (_ error: MWError, _ response: MWResponse? ) -> Void

class MWNetwork {
    // MARK: - variables
    static let shared = MWNetwork()
    private var queue = DispatchQueue(label: "Network", qos: .background, attributes: .concurrent)
    private var session = URLSession.init(configuration: .default)
    private let baseUrl: String = "https://api.themoviedb.org/3/"
    private let api_key: String = "79d5894567be5b76ab7434fc12879584"
    private var params: [String: String] = ["api_key": "79d5894567be5b76ab7434fc12879584",
                                            "language": NSLocalizedString("en", comment: "")]

    // MARK: - initialization
    private init() {}

    // MARK: - request
    func request<T: Decodable>(url: String,
                               params: [String: String]? = nil,
                               okHandler: @escaping Success<T>,
                               errorHandler: @escaping Failure) {
        if let params = params {
            self.params.merge(params) { (_, new) in new }
        }
        var fullPath = self.baseUrl + url
        fullPath = self.getUrlWithParams(fullPath: fullPath, params: self.params)
        guard let url = URL(string: fullPath) else {
            errorHandler(.incorrectUrl(url: fullPath), .none)
            return
        }
        
        let request = URLRequest(url: url)
        self.session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else { return }
                if error != nil {
                    errorHandler(.serverError(statusCode: response.statusCode ),
                                 .response(code: response.statusCode))
                    return
                }
                guard let data = data else { return }
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    okHandler(result, .response(code: response.statusCode))
                } else {
                    if error != nil {
                        errorHandler(.parsingError(error: error!), .response(code: response.statusCode))
                    } else {
                        errorHandler(.other(info: "parsing"), .response(code: response.statusCode))
                    }
                    return
                }
            }
        }.resume()
    }
}
