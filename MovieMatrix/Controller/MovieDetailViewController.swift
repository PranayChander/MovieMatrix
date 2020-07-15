//
//  MovieDetailViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var watchlistBarButtonItem: UIButton!
    @IBOutlet weak private var favoriteBarButtonItem: UIButton!
    @IBOutlet weak private var ratingView: MovieRatingView!
    @IBOutlet weak private var movieName: UILabel!
    @IBOutlet weak private var releaseYear: UILabel!
    @IBOutlet weak private var overviewTextLabel: UILabel!
    
    var movie: Movie!
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    private var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieName.text = movie.title
        overviewTextLabel.text = movie.overview
        releaseYear.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: movie.releaseDate)
        MMNetworkClient.getMovieImage(imageName: movie.posterPath!) { (image, error) in
            if let movieImage = image {
                DispatchQueue.main.async {
                    self.imageView.image = movieImage
                }
            }
        }
        watchlistBarButtonItem.toggle(enabled: isWatchlist)
        favoriteBarButtonItem.toggle(enabled: isFavorite)
        ratingView.setProgress(value: movie.voteAverage / 10.0, withAnimation: true, duration: 1.0)
    }
    
    @IBAction func watchlistButtonTapped(_ sender: UIButton) {
        let markedMovie = MarkWatchList(mediaType: MediaType.movie.rawValue, mediaID: movie.id, watchList: !isWatchlist)
        MMNetworkClient.updateWatchList(markWatchList: markedMovie) { (success, error) in
            if success {
                if self.isWatchlist {
                    MovieModel.watchlist = MovieModel.watchlist.filter {$0 != self.movie}
                } else {
                    MovieModel.watchlist.append(self.movie)
                }
                DispatchQueue.main.async {
                    self.watchlistBarButtonItem.toggle(enabled: self.isWatchlist)
                }
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let favoritedMovie = MarkFavorite(mediaType: MediaType.movie.rawValue, mediaID: movie.id, favorite: !isFavorite)
        MMNetworkClient.updateFavoritesList(markFavorite: favoritedMovie){ (success, error) in
            if success {
                if self.isFavorite {
                    MovieModel.favorites = MovieModel.favorites.filter {$0 != self.movie}
                } else {
                    MovieModel.favorites.append(self.movie)
                }
                DispatchQueue.main.async {
                    self.favoriteBarButtonItem.toggle(enabled: self.isFavorite)
                }
            }
        }
    }
}
