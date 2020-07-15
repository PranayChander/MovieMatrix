//
//  MosaicCollectionViewLayout.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MosaicCollectionViewLayout: UICollectionViewLayout {
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else {
            return
        }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        
//        createAttributes()
    }

    override var collectionViewContentSize: CGSize {
        contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else {
            return false
        }
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { (attributes) -> Bool in
            return rect.intersects(attributes.frame)
        }
    }
}
