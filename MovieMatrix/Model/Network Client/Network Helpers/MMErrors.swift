//
//  MMErrors.swift
//  MovieMatrix
//
//  Created by pranay chander on 16/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

enum MMError: Error {
    case unknown
    
    case httpError(NetworkErrorCode)
    
    case invalidResponse
    case missingRequiredProperty
    case missingID
    
    case permissionDenied
    case notAuthenticated
    case somethingWentWrong
    
    case notReachable
    case timeout
    case sessionExpired
    case userChanged
    case connectionAbort
    
    case coreDataError(Error?)
    case genericCocoaError(Error)
    
    var description: String {
        switch  self {
        case .unknown:
            return "Unknown Error"
            case .httpError(let error):
                return "Network Error: \(error.description)"
            case .invalidResponse:
            return "The Network Response is invalid"
            case .missingRequiredProperty:
            return "The Network Response is missing Required Property"
            case .missingID:
            return "The Network Response is missing ID Property"
            case .permissionDenied:
            return "Permission Denied"
        
        case .notAuthenticated:
            return "User Could Not be Authenticated"
        case .somethingWentWrong:
            return "Something Went Wrong"
        case .notReachable:
            return "Server Not Reachable"
        case .timeout:
            return "Request Timeout"
        case .sessionExpired:
            return "Session Expired"
        case .userChanged:
            return "User Changed"
        case .connectionAbort:
            return "Connection aborted"
        case .coreDataError(let error):
            return "Core data error: \(error?.localizedDescription ?? "General Error") "
        case .genericCocoaError(let error):
            return "Generic cocoa error: \(error.localizedDescription)"
        }
    }
}

enum NetworkErrorCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorised = 401
    case forbidden = 403
    case serverError = 500
    case unknown = 0
    
    var description: String {
        switch  self {
        case .success:
            return "Success Request"
            case .badRequest:
            return "A required attribute of the API is missing"
            case .unauthorised:
            return "The user is unauthenticated"
            case .forbidden:
            return "Access to the resource is forbidden"
            case .serverError:
            return "Server encountered an error while fulfilling the request"
            case .unknown:
            return "No error code found"
    
        }
    }
    
}
