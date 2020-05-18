//
//  MWSystem.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/7/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

class MWSystem {
    // MARK: - variables
    static let shared = MWSystem()
    private let persistace = MWPersistenceService.shared

    // MARK: - initialization
    private init() {}
    
    
    // MARK: - request
    func requestGenres(completion: @escaping ([Genre]) -> Void) {
        MWNetwork.shared.request(
            url: "genre/movie/list",
            okHandler: { [weak self] (data: APIGenres, response) in
                guard let self = self else { return }
                data.genres.forEach {
                    let genre = Genre(context: self.persistace.context)
                    genre.id = Int32($0.id)
                    genre.name = $0.name
                }
                
                DispatchQueue.main.async {
                    self.persistace.save {
                        self.persistace.fetch(Genre.self, completion: { (genres) in
                            completion(genres)
                        })
                    }
                }
        }) { (error, response) in
            print(error.localizedDescription)
        }
    }
}
