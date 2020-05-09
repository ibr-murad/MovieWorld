//
//  MWMainSection.swift
//  MovieWorld
//
//  Created by Murad Ibrohimov on 5/7/20.
//  Copyright © 2020 Murad. All rights reserved.
//

import Foundation

enum MWMainSections {
    case nowPlaying, popular, topRated, upcoming
    
    func getSectionModel() -> MWMainSection {
        switch self {
        case .nowPlaying:
            return MWMainSection(title: "Now playing", urlPath: MWURLPath.nowPlaing)
        case .popular:
            return MWMainSection(title: "Popular", urlPath: MWURLPath.popular)
        case .topRated:
            return MWMainSection(title: "Top Rated", urlPath: MWURLPath.topRated)
        case .upcoming:
            return MWMainSection(title: "Upcoming", urlPath: MWURLPath.upcoming)
        }
    }
}

struct MWMainSection {
    let title: String
    let urlPath: String
}
