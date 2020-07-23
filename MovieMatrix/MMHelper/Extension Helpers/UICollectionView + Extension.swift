//
//  UICollectionView + Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 20/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCollectionViewCell(withIdentifier identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
}
