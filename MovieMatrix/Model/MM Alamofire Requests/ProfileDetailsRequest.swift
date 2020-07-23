//
//  ProfileDetailsRequest.swift
//  MovieMatrix
//
//  Created by pranay chander on 16/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation


struct ProfileDetailsRequest: GETRequest {
    var endpoint = "https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9"
    var localFileName = "MMProfileDetailsResponse"
}


struct ProfileDetailAPIService: APIService {
    typealias Request = ProfileDetailsRequest
    
    static func performNetworkService(request: ProfileDetailsRequest, completion: @escaping ((Response) -> Void)) {
        if MMEnvironment.current == .MOCKED {
            MMAlamofireNetworkService.fetchLocalJSON(request) { (data) in
                completion(Response(data: data, error: data == nil ? MMError.invalidResponse : nil))
            }
        } else {
            MMAlamofireNetworkService.performNetworkService(request, completion: completion)
        }
    }
}
