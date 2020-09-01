//
//  File Manager + Extensions.swift
//  MovieMatrix
//
//  Created by pranay chander on 21/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

extension FileManager {
    func createPath(_ path: String) {
        do {
            let _ = try self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            debugPrint("Couldn't create directory")
        }
    }
    
    static func applicationDocumentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last!
    }
    
    static func applicationDocumentsDirectorPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }
}
