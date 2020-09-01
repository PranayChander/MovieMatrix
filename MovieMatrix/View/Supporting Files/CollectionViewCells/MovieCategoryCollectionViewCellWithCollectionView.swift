//
//  MovieCategoryCollectionViewCellWithCollectionView.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieCategoryCollectionViewCellWithCollectionView: UICollectionViewCell, NibLoadableView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.MMRegister(MovieCategoryCollectionViewCell.self)
    }

}

extension MovieCategoryCollectionViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieCategoryCollectionViewCell = collectionView.MMDequeueReusableCell(for: indexPath)
        return cell
    }
}

extension MovieCategoryCollectionViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
