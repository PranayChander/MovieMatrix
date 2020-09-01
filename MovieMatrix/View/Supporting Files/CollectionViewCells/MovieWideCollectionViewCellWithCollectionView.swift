//
//  MovieWideCollectionViewCellWithCollectionView.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieWideCollectionViewCellWithCollectionView: UICollectionViewCell, NibLoadableView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] {
        return MovieModel.NowShowing
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.MMRegister(MovieWideCollectionViewCell.self)
    }
    
    func updateCollection() {
        DispatchQueue.main.async {
            self.pageControl.numberOfPages = self.movies.count
            self.collectionView.reloadData()
        }
    }
}

extension MovieWideCollectionViewCellWithCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MovieWideCollectionViewCell = collectionView.MMDequeueReusableCell(for: indexPath)
        let movie = movies[indexPath.row]
        if let posterPath = movie.posterPath {
            MMNetworkClient.getMovieImage(imageName: posterPath) { (image, error) in
                if let movieImage = image {
                    DispatchQueue.main.async {
                        cell.movieImage.image = movieImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
}

extension MovieWideCollectionViewCellWithCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 20, height: 200)
    }
}

extension MovieWideCollectionViewCellWithCollectionView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / (self.frame.width - 20)
        pageControl.currentPage = Int(scrollPos)
    }
}
