//
//  MMNetworkClient.swift
//  MovieMatrix
//
//  Created by pranay chander on 07/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class MMNetworkClient {
    static let apiKey = "651957a2e8ec299667a8322ff63576c7"
    static let reachability = NetworkReachabilityManager()
    
    struct Auth {
        static var accountId = 0
        static var requestToken = MMUtilities.sharedInstance.getRequestToken() ?? ""
        static var sessionId = MMUtilities.sharedInstance.getSessionID() ?? ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(MMNetworkClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case login
        case startSession
        case oAuth
        case endSession
        case getFavorites
        case search(String)
        case markWatchlist
        case markFavorite
        case getMovieImage(String)
        
        var stringValue: String {
            switch self {
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .login: return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .startSession: return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .oAuth: return "https://www.themoviedb.org/authenticate/" + Auth.requestToken + "?redirect_to=moviematrix:authenticate"
            case .endSession: return Endpoints.base + "/authentication/session" + Endpoints.apiKeyParam
            case .getFavorites: return Endpoints.base + "/account/\(Auth.accountId)/favorite/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .search(let query): return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  ?? "")"
            case .markWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .markFavorite: return Endpoints.base + "/account/\(Auth.accountId)/favorite" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getMovieImage(let imageName): return "https://image.tmdb.org/t/p/w500/" + imageName
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func isReachable()-> Bool {
        return MMNetworkClient.reachability?.isReachable ?? false
     }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            
            // can be used if snakeCasing followed for all Get Requests
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    completion(nil,errorResponse)
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    completion(nil,errorResponse)
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getWatchlist.url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getWatchlistCRD(completion: @escaping ([UserMovie]?, Error?) -> Void) {
        URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { (data, response, error) in
            if let data = data {
                do {
                    let watchListJson = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    UserMovie.saveUserMovies(movieJSON: watchListJson["results"] as! [[String: Any]], user: UserProfile.getUserDetails()!)
                    completion(nil,nil)
                } catch {
                    completion(nil,nil)
                }
                completion(nil,nil)
            }
        }.resume()
    }
    
    class func getFavorites(completion: @escaping([Movie],Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getFavorites.url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getSearchList(query: String, completion: @escaping([Movie],Error?) -> Void) -> URLSessionTask {
        let task = taskForGETRequest(url: Endpoints.search(query).url, responseType: MovieResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
        return task
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getRequestToken.url, responseType: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                completion(response.success, nil)
                Auth.requestToken = response.requestToken
                MMUtilities.sharedInstance.saveRequestToken(requestToken: response.requestToken)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getMovieImage(imageName: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let imageURL = Endpoints.getMovieImage(imageName).url
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let localError = error as? URLError{
                //Checking For Constrained Network Reason.low data network
                if localError.networkUnavailableReason == .constrained {
                    //URL Session.fetch low resolusion image
                }
                completion(nil, error)
            } else {
                if let data = data {
                    completion(UIImage(data: data), nil)
                } else {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    class func userLogin(userName: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        if MMNetworkClient.isReachable() {
        let body = LoginRequest(username: userName, password: password, requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.requestToken = response.requestToken
                MMUtilities.sharedInstance.saveRequestToken(requestToken: response.requestToken)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        } else {
            completion(false, nil)
        }
    }
    
    class func startSession(completion: @escaping(Bool, Error?) -> Void) {
        let body = PostSession(requestToken: Auth.requestToken)
        taskForPOSTRequest(url: Endpoints.startSession.url, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.sessionID
                MMUtilities.sharedInstance.saveSessionID(sessionID: response.sessionID)
                MMUtilities.sharedInstance.saveSessionStartTime()
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateWatchList(markWatchList: MarkWatchList, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.markWatchlist.url, responseType: TMDBResponse.self, body: markWatchList) { (response, error) in
            if response?.statusCode == 0 || response?.statusCode == 1 || response?.statusCode == 12 || response?.statusCode == 13 {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateFavoritesList(markFavorite: MarkFavorite, completion: @escaping(Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.markFavorite.url, responseType: TMDBResponse.self, body: markFavorite) { (response, error) in
            if response?.statusCode == 0 || response?.statusCode == 1 || response?.statusCode == 12 || response?.statusCode == 13 {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func endSession(completion: @escaping(Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.endSession.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = Logout(sessionID: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool]
                if responseObject?["success"] == true {
                    Auth.requestToken = ""
                    Auth.sessionId = ""
                    completion(true,nil)
                } else {
                    completion(false,error)
                }
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
}

//Mark: A network request in the background
extension MMNetworkClient {
    class func performMMSessionNetworkRequest() {
        let config = URLSessionConfiguration.background(withIdentifier: "com.mm.background.url.example")
        
        //waits for connection to end
        config.waitsForConnectivity = true
        config.isDiscretionary = true
        let delegate = MMNetworkClientSessionDelegate()
        let url = URL(string: "https://www.google.com")!
        
        let delegateQueue = OperationQueue()
        let session = URLSession(configuration: config, delegate: delegate, delegateQueue: delegateQueue)
        
        let task = session.dataTask(with: url)
        task.earliestBeginDate = Date(timeIntervalSinceNow: 60) //One minute from now
        task.resume()
    }
}
