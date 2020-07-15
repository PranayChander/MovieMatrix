//
//  ConfigurationHandler.swift
//  MovieMatrix
//
//  Created by pranay chander on 15/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

class ConfigurationHandler {
    static let sharedInstance = ConfigurationHandler()
    private init() {}
    
    //USING USER DEFINED SETTINGS -> Update info.plist and User Setting in Target Bundle Settings
    func getAppID() -> String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let infoDict = NSDictionary(contentsOfFile: path), let appID = infoDict["APP_ID"] as? String {
            return appID
        }
        return ""
    }
    
    //USING XCCONFIG -> Update info.plist and string in XCConfig, map Config accordingly in PROJECT/INFO/CONFIGURATION (if value to be used in program then add to plist else can be can be directly inherited from xcConfig in Project Settings)
    func getAppName() -> String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") , let infoDict = NSDictionary(contentsOfFile: path),let appName =  infoDict["APPLICATION_NAME"] as? String {
            return appName
        }
        return ""
    }
    
    //Using Environment Variable -> Set in Arguments in manage schemes for particular scheme
    func getEnvironment() -> String {
        let environmentDictionary = ProcessInfo.processInfo.environment
        if let env = environmentDictionary["MMenvironment"] {
            return env
        }
        return ""
    }
    
    //Generic Method to access any key
    func infoForKey(_ key: String) -> String? {
            return (Bundle.main.infoDictionary?[key] as? String)?
                .replacingOccurrences(of: "\\", with: "")
     }
}
