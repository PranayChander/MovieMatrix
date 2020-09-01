//
//  NowShowingNetworkRequest.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct NowShowingNetworkRequest: GETRequest {
    var endpoint = MMNetworkClient.Endpoints.nowShowing.stringValue
    var localFileName = "MMNowShowingResponse"
}

struct NowShowingAPIService: APIService {
    typealias Request = NowShowingNetworkRequest
    static func performNetworkService(request: NowShowingNetworkRequest, completion: @escaping ((Response) -> Void)) {
        if MMEnvironment.current == .MOCKED {
            MMAlamofireNetworkService.fetchLocalJSON(request) { (data) in
                
                //TODO: Parse to Movie Model
                if let json = data, let favorites = json["results"] as? [[String: Any]] {
                    completion(Response(data: data, error: data == nil ? MMError.invalidResponse : nil))
                }
            }
        } else {
            MMNetworkClient.getNowShowing { (movies, error) in
                if error != nil {
                    completion(Response(data: nil, error: error))
                } else {
                    MovieModel.NowShowing = movies
                    completion(Response(data: ["response": "sucess"], error: nil))
                }
            }
        }
    }
}
