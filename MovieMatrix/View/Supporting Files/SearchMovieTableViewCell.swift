//
//  SearchMovieTableViewCell.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ratingIndicator: MovieRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
