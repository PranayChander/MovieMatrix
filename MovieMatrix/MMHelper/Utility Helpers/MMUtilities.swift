//
//  MMUtilities.swift
//  MovieMatrix
//
//  Created by pranay chander on 10/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation
import os.log

class MMUtilities {
    //        DateComponentsFormatter
    //        DateIntervalFormatter
    //        RelativeDateTimeFormatter
    //        DateFormatter().setLocalizedDateFormatFromTemplate(T##dateFormatTemplate: String##String)
    //        PersonNameComponentsFormatter - for monograms
    //        ListFormatter
    //        NumberFormatter
    
    
    static let sharedInstance = MMUtilities()
    private init(){}
    
    func getformattedDateForString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateStyle = .long
        let longFormatString = dateFormatter.string(from: date!)
        return longFormatString
    }
    func operationQ() {
//        let op = Operation()
//        let op2 = Operation()
//        op2.addDependency(op)
//        op2.obse
//        let oprationQues = OperationQueue()
//        oprationQues.addOperations([op, op2], waitUntilFinished: true)
//        let blk = BlockOperation()
//        DispatchQueue.global().async {
//            <#code#>
//        }
    
    }
}

extension MMUtilities {
    func saveSessionID(sessionID: String) {
        UserDefaults.standard.set(sessionID, forKey: MMUserDefaultKeys.sessionID)
    }
    
    func saveRequestToken(requestToken: String) {
        UserDefaults.standard.set(requestToken, forKey: MMUserDefaultKeys.requestToken)
    }
    func saveSessionStartTime() {
        UserDefaults.standard.set(Date(), forKey: MMUserDefaultKeys.sessionValidityTime)
    }
    
    func getSessionID() -> String? {
        return UserDefaults.standard.value(forKey: MMUserDefaultKeys.sessionID) as? String
    }
    
    func getRequestToken()-> String? {
        return UserDefaults.standard.value(forKey: MMUserDefaultKeys.requestToken) as? String
    }
    func getSessionStartTime() -> Date? {
        return UserDefaults.standard.value(forKey: MMUserDefaultKeys.sessionValidityTime) as? Date
    }
    
    func isValidSession() -> Bool {
        if let sessionStartTime = UserDefaults.standard.value(forKey: MMUserDefaultKeys.sessionValidityTime) as? Date, sessionStartTime.distance(to: Date()) < 3600 {
            return true
        }
        return false
    }
}

extension MMUtilities {
    func logMessage(_ message: String) {
        os_log("Log Messag", message)
    }
    
    func isUITesting() -> Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-Testing")
    }
}

