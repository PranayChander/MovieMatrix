//
//  WatchlistNetworkRequest.swift
//  MovieMatrix
//
//  Created by pranay chander on 04/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct WatchlistNetworkRequest: GETRequest {
    var endpoint = MMNetworkClient.Endpoints.getWatchlist.stringValue
    var localFileName = "MMWatchListResponse"
}

struct WatchlistAPIService: APIService {
    typealias Request = WatchlistNetworkRequest
    static func performNetworkService(request: WatchlistNetworkRequest, completion: @escaping ((Response) -> Void)) {
        
        UserProfile.getUserDetails { (user) in
            if let user = user {
                if MMEnvironment.current == .MOCKED {
                    MMAlamofireNetworkService.fetchLocalJSON(request) { (data) in
                        if let json = data, let watchList = json["results"] as? [[String: Any]] {
                            UserMovie.saveUserMovies(movieJSON: watchList, user: user, isWatchlisted: true)
                            completion(Response(data: data, error: data == nil ? MMError.invalidResponse : nil))
                            
                        }
                    }
                } else {
                    MMAlamofireNetworkService.performNetworkService(request, parameters: nil) { (response) in
                        if let data = response.data {
                            UserMovie.saveUserMovies(movieJSON: data["results"] as! [[String: Any]], user: user, isWatchlisted: true)
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

