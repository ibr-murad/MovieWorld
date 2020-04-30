//
//  MWMovie.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 4/10/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import UIKit

struct MWMovie {
    let id: Int
    let title: String
    let year: String
    let poster: UIImage
    let genres: [String]
    let rating: Double
    let overview: String
    //let videoPath: String?
    public static func getImageByPath(path: String? = nil) -> UIImage? {
        if let path = path {
            guard let imageURL = URL(string: (MWNetwork.imageBaseUrl + path)) else { return UIImage(named: "movie") }
            guard let resource = try? Data(contentsOf: imageURL) else { return UIImage(named: "movie") }
            return UIImage(data: resource)
        }
        return UIImage(named: "movie")
    }

}
