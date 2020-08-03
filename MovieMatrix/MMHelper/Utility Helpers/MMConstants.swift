//
//  MMConstants.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import Foundation

struct MMUserDefaultKeys {
    static let sessionID = "sessionID"
    static let requestToken = "requestToken"
    static let sessionValidityTime = "sessionTime"
}

struct MMSegueIdentifiers {
    static let movieDetail = "showDetail"
    static let loginComplete = "completeLogin"
}

struct MMTableViewCellIdentifiers {
    static let searchCell = "SearchMovieTableViewCell"
}

struct MMCollectionViewCellIdentifiers {
    static let movieCell = "MovieCollectionViewCell"
}

struct MMStringConstants {
    static let loginFailed = "Login Failed"
    static let OK = "OK"
}

struct MMErrorStrings {
    static let coreDataFetchError = "Could Fetch From Persistent Store"
}

