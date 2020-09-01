//
//  MovieListTableViewCell.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell, NibLoadableView  {
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var pillView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pillView.layer.cornerRadius = 26.0
    }
}

