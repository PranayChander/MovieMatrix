//
//  MovieCategoryCollectionViewCell.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieCategoryCollectionViewCell: UICollectionViewCell, NibLoadableView  {
    @IBOutlet weak private var categoryImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 5.0
    }
}
