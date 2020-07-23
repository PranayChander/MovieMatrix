//
//  ConfigurationPersistanceService.swift
//  MovieMatrix
//
//  Created by pranay chander on 21/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

class ConfigurationPersistanceService {
    private static var configurationFilePath: String {
        var path = FileManager.applicationDocumentsDirectorPath()
        path.append("/Configuration")
        FileManager.default.createPath(path)
        path.append("/Configurations.json")
        return path
    }
    
    static func save(data: [String: Any]) {
        do {
            self.remove()
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            try jsonData.write(to: URL(fileURLWithPath: self.configurationFilePath ), options: .atomic)
        } catch {
            debugPrint("could not save")
        }
    }
    
    static func remove() {
        do {
            try FileManager.default.removeItem(atPath: self.configurationFilePath)
        } catch {
            debugPrint("Error Deleting")
        }
    }
    
    static func retrieve() -> [String: Any]? {
        do {
            if let jsonData = FileManager.default.contents(atPath: self.configurationFilePath) {
                if let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return data
                }
                debugPrint("Error retrieving data")
            }
            return nil
        } catch {
            return nil
        }
    }
}
