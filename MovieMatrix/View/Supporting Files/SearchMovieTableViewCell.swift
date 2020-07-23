//
//  SearchMovieTableViewCell.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
import Combine

class SearchMovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ratingIndicator: MovieRatingView!
    
    // Using combine in searchVC
    var subscriber: AnyCancellable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImage.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        subscriber?.cancel()
    }

}
