//
//  MovieCollectionViewLayout.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieCollectionViewLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        
        let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        let minColumnWidth = CGFloat(100.0)
        let maxNumberOfColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumberOfColumns)).rounded(.down)
        self.itemSize = CGSize(width: cellWidth, height: 120.0)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0, bottom: 0, right: 0)
        self.sectionInsetReference = .fromSafeArea
    }
}
