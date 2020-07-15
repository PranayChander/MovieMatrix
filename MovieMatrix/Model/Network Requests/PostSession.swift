//
//  PostSession.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let requestToken: String
    
    enum CodingKeys:String, CodingKey {
        case requestToken = "request_token"
    }
}
