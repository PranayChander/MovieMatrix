//
//  LogoutRequest.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct Logout: Codable {
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
    }
}
