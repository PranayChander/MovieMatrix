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
    static let movieListCell = "MovieListTableViewCell"
}

struct MMCollectionViewCellIdentifiers {
    static let movieRegularCellWithCV = "MovieRegularCollectionViewCellWithCollectionView"
    static let movieRegularCell = "MovieRegularCollectionViewCell"
    static let movieCategoryCellWithCV = "MovieCategoryCollectionViewCellWithCollectionView"
    static let movieCategoryCell = "MovieCategoryCollectionViewCell"
    static let movieWideCellWithCV = "MovieWideCollectionViewCellWithCollectionView"
    static let movieWideCell = "MovieWideCollectionViewCell"
    static let movieListCellWithTV = "MovieListCollectionViewCellWithTableView"
}

struct MMStringConstants {
    static let loginFailed = "Login Failed"
    static let OK = "OK"
}

struct MMErrorStrings {
    static let coreDataFetchError = "Could Fetch From Persistent Store"
    static let noUserError = "User doesnt exist"
}

