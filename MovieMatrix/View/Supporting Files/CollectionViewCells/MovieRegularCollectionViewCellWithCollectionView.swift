//
//  MovieRegularCollectionViewCellWithCollectionView.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

enum RegularCollectionViewType: String {
    case TopRated = "Top Rated"
    case Popular = "Popular"
}

class MovieRegularCollectionViewCellWithCollectionView: UICollectionViewCell, NibLoadableView {
    @IBOutlet weak var collectionView: UICollectionView!
    var type: RegularCollectionViewType = .TopRated
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.MMRegister(MovieRegularCollectionViewCell.self)
        title.text = type.rawValue
    }
}

extension MovieRegularCollectionViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieRegularCollectionViewCell = collectionView.MMDequeueReusableCell(for: indexPath)
        cell.movieName.text = "movie...\(indexPath.row)"
        cell.ratingStackView.isHidden = type == .Popular
        return cell
    }
    
}

extension MovieRegularCollectionViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return type == .TopRated ? CGSize(width: 120, height: 180) : CGSize(width: 120, height: 180 - 25)
    }
}
