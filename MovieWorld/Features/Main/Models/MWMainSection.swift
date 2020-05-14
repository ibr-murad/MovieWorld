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
            return MWMainSection(title: NSLocalizedString("nowPlaing", comment: ""), urlPath: MWURLPath.nowPlaing)
        case .popular:
            return MWMainSection(title: NSLocalizedString("popular", comment: ""), urlPath: MWURLPath.popular)
        case .topRated:
            return MWMainSection(title: NSLocalizedString("topRated", comment: ""), urlPath: MWURLPath.topRated)
        case .upcoming:
            return MWMainSection(title: NSLocalizedString("upcoming", comment: ""), urlPath: MWURLPath.upcoming)
        }
    }
}

struct MWMainSection {
    let title: String
    let urlPath: String
}
