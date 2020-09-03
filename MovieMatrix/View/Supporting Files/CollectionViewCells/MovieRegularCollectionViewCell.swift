//
//  MovieRegularCollectionViewCell.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieRegularCollectionViewCell: UICollectionViewCell, NibLoadableView {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.movieImage.layer.cornerRadius = 10.0
    }
}
