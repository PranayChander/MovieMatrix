//
//  Movie.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

//Swift provides a synthesized implementation of Equatable for the following kinds of custom types:
//https://docs.swift.org/swift-book/LanguageGuide/Protocols.html
//Structures that have only stored properties that conform to the Equatable protocol
//Enumerations that have only associated types that conform to the Equatable protocol
//Enumerations that have no associated types

//Conforming to Equatable so that movies can be filtered based on struct
// All attributes conform to equatable in the struct

struct Movie: Codable, Equatable, Hashable {
    
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Double
    
    var releaseYear: String {
        return String(releaseDate.prefix(4))
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
