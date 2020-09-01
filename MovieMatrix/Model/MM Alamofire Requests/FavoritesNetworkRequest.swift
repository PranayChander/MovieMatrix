//
//  FavoritesNetworkRequest.swift
//  MovieMatrix
//
//  Created by pranay chander on 10/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct FavoritesNetworkRequest: GETRequest {
    var endpoint = MMNetworkClient.Endpoints.getFavorites.stringValue
    var localFileName = "MMFavoritesResponse"
}

struct FavoritesAPIService: APIService {
    typealias Request = FavoritesNetworkRequest
    static func performNetworkService(request: FavoritesNetworkRequest, completion: @escaping ((Response) -> Void)) {
        
        UserProfile.getUserDetails { (user) in
            if let user = user {
                if MMEnvironment.current == .MOCKED {
                    MMAlamofireNetworkService.fetchLocalJSON(request) { (data) in
                        if let json = data, let favorites = json["results"] as? [[String: Any]] {
                            UserMovie.saveUserMovies(movieJSON: favorites, user: user, isFavorites: true)
                            completion(Response(data: data, error: data == nil ? MMError.invalidResponse : nil))
                        }
                    }
                } else {
                    MMAlamofireNetworkService.performNetworkService(request, parameters: nil) { (response) in
                        if let data = response.data {
                            UserMovie.saveUserMovies(movieJSON: data["results"] as! [[String: Any]], user: user, isFavorites: true)
                            completion(response)
                        } else {
                            completion(Response(data: nil, error: MMError.missingID))
                        }
                    }
                }
            } else {
                completion(Response(data: nil, error: MMError.missingID))
            }
        }
    }
}

