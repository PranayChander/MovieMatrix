//
//  RequestTokenResponse.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiry: String
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiry = "expires_at"
        case requestToken = "request_token"
    }
}
