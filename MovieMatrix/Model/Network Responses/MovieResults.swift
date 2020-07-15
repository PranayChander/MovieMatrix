//
//  MovieResults.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
