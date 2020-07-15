//
//  SessionResponse.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let success: Bool
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
