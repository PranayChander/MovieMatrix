//
//  MarkWatchlist.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct MarkWatchList: Codable {
    let mediaType: String
    let mediaID: Int
    let watchList: Bool
    
    enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
        case mediaID = "media_id"
        case watchList = "watchlist"
    }
}
