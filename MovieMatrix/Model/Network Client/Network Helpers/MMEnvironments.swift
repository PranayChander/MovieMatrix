//
//  MMEnvironments.swift
//  MovieMatrix
//
//  Created by pranay chander on 16/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

enum EnvironmentType: String {
    case MOCKED
    case DEBUG
    case PROD
}

struct MMEnvironment {
    static let current: EnvironmentType = {
        return EnvironmentType(rawValue: ConfigurationHandler.sharedInstance.getEnvironment()) ?? .MOCKED
    }()
}

