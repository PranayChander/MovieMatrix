//
//  MMAlamofireNetworkClient.swift
//  MovieMatrix
//
//  Created by pranay chander on 16/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation
import Alamofire


protocol Request {
    var endpoint: String {get}
    var localFileName: String {get}
    var requestType: Alamofire.HTTPMethod {get}
    var encoding: ParameterEncoding {get}
}

public final class Response {
    let data: [String: AnyObject]?
    let error: Error?
    init(data: [String: AnyObject]?, error: Error?) {
        self.data = data
        self.error = error
    }
}

//1.For Gettable Protocol Properties , the requirement can be satisfied by any kind of property, and it is valid for the property to be also settable if this is useful for your own code.
//2.For Gettable & Settable Protocol Property, the requirement CANNOT be fulfilled by a constantly stored property or a read-only computed property.
//3.Property requirements in a protocol are always declared as variable properties because they are declared as computed properties.
//https://medium.com/@chetan15aga/swift-protocols-properties-distinction-get-get-set-32a34a7f16e9
//https://vishal-singh-panwar.github.io/SwiftProtocols/

//Initial values not allowed in protocol so extending below
protocol GETRequest: Request {}
protocol POSTRequest: Request {}
protocol PUTRequest: Request {}
protocol DELETERequest: Request {}


// Extending the protocol to add additional functionality
extension GETRequest {
    var requestType: Alamofire.HTTPMethod { return .get}
    var encoding: ParameterEncoding {return URLEncoding.default}
}

extension POSTRequest {
    var requestType: Alamofire.HTTPMethod { return .post}
    var encoding: ParameterEncoding {return JSONEncoding.default}
}

extension PUTRequest {
    var requestType: Alamofire.HTTPMethod { return .put}
    var encoding: ParameterEncoding {return JSONEncoding.default}
}

extension DELETERequest {
    var requestType: Alamofire.HTTPMethod { return .delete}
    var encoding: ParameterEncoding {return JSONEncoding.default}
}


protocol APIService {
    associatedtype Request
    static func performNetworkService(request: Request, completion: @escaping((Response) -> Void))
}

enum HeaderParams: String {
    case userID
    case AuthToken
    case timeZone
    case appVersion
    case buildVersion
    case ipAddress
    case deviceType
    
    var paramName: String {
        switch self {
        case .userID:
            return "User-ID"
        case .AuthToken:
            return "Auth-Token"
        case .timeZone:
            return "TimeZone"
        case .appVersion:
            return "AppVersion"
        case .buildVersion:
            return "BuildVersion"
        case .ipAddress:
            return "IP-Address"
        case .deviceType:
            return "Device-Type"
            
        }
    }
}
public struct RequestHeader {
    var userID: String
    var AuthToken: String
    var timeZone: String
    var appVersion: String
    var buildVersion: String
    var ipAddress: String
    var deviceType: String
}

// If using delegate protocol method to get the response
public protocol NetworkServiceDelegate: class {
    func networkServiceCompletion(service: MMAlamofireNetworkService, urlResponse: HTTPURLResponse, responseBody: Data?)
    func loadSuccessErrorView(message: String, imageName: String)
}

extension NetworkServiceDelegate {
    func networkServiceCompletion(service: MMAlamofireNetworkService, urlResponse: HTTPURLResponse, responseBody: Data?) {}
    func loadSuccessErrorView(message: String, imageName: String) {}
}

protocol NetworkTestsDelegate: class {
    func testingJSONResponse(request: Request) -> [String: AnyObject]?
}

public enum ReachablityStatus {
    case reachable
    case unReachable
    case unknown
}
public class MMAlamofireNetworkService {
    public static let sharedInstance = MMAlamofireNetworkService()
    public static let NetworkReachablityStatus = Notification.Name.init(rawValue: "NetworkReachablityStatus") // Notification Name Constant
    
    weak var testsDelegate: NetworkTestsDelegate?
    private let reachability = NetworkReachabilityManager()
    
    weak public var delegate: NetworkServiceDelegate? {
        didSet {
            self.reachability?.startListening(onUpdatePerforming: { (status) in
                var reachablityStatus: ReachablityStatus?
                switch status {
                case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                    reachablityStatus = .reachable
                case .notReachable:
                    reachablityStatus = .unReachable
                case .unknown:
                    reachablityStatus = .unknown
                }
                NotificationCenter.default.post(name: MMAlamofireNetworkService.NetworkReachablityStatus, object: reachablityStatus)
            })
            
        }
    }
    
    public func isReachable() -> Bool {
        return self.reachability?.isReachable ?? false
    }
    
    static func performNetworkService(_ request: Request, parameters: [String: Any]? = nil, completion: @escaping((Response) -> Void)) {
        if MMAlamofireNetworkService.sharedInstance.isReachable() {
            AF.request(request.endpoint).response { (response) in
                print(response)
            }
        } else {
            completion(Response(data: nil, error: MMError.notReachable))
        }
    }
}

extension MMAlamofireNetworkService {
    
    static func fetchLocalJSON(_ request: Request, completion: ((_ data: [String: AnyObject]?) -> Void)?) {
        var jsonResult: [String: AnyObject]!
        // Set the netwrok service delegate in the testcase , conform the test case class to NetworkTestsDelegate and send the fileName via delegate
        
//          func testingJSONResponse(request: Request) -> [String: AnyObject]? {
//        return MMJSONFileHelper.fetchJSON("ProfileDetailsPositiveTestResponse")
//    }
        
        
        if let testDelegate = MMAlamofireNetworkService.sharedInstance.testsDelegate {
            if let result = testDelegate.testingJSONResponse(request: request) {
                jsonResult = result
                completion?(jsonResult)
            } else {
                completion?(nil)
            }
        } else {
            DispatchQueue.global().async {
                sleep(UInt32(1.0))
                jsonResult = MMJSONFileHelper.fetchJSON(request.localFileName)
                completion?(jsonResult)
            }
        }
    }
}
