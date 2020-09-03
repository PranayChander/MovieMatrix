//
//  MMJSONFileHelper.swift
//  MovieMatrix
//
//  Created by pranay chander on 16/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

class MMJSONFileHelper {
    static func fetchJSON(_ filename: String, bundleIdentifier: String? = nil) -> [String: AnyObject]? {
        var jsonResult: [String: AnyObject]?
        var filePath: String?
        if let bundleIdentifier = bundleIdentifier {
            filePath = Bundle(identifier: bundleIdentifier)?.path(forResource: filename, ofType: "json")
        } else {
            filePath = Bundle.main.path(forResource: filename, ofType: "json")
        }
        guard let validfilePath = filePath else {
            return nil
        }
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: validfilePath), options: .mappedIfSafe)
            do {
                jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: AnyObject]
            } catch {
                return nil
            }
        } catch {
            return nil
        }
        return jsonResult
    }
}
