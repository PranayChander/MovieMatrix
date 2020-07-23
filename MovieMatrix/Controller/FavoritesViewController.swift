//
//  FavoritesViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerTableViewCell(withIdentifier: MMTableViewCellIdentifiers.searchCell)
        tableView.tableFooterView = UIView()
        _ = MMNetworkClient.getFavorites(completion: { (movies, error) in
            MovieModel.favorites = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MMSegueIdentifiers.movieDetail {
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.movie = MovieModel.favorites[selectedIndex]
        }
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellIdentifiers.searchCell) as? SearchMovieTableViewCell
        let movie = MovieModel.favorites[indexPath.row]
        cell?.movieName.text = movie.title
        cell?.releaseDate.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: movie.releaseDate)
        cell?.ratingIndicator.setProgress(value: movie.voteAverage / 10.0)
        if let posterPath = movie.posterPath {
            MMNetworkClient.getMovieImage(imageName: posterPath) { (image, error) in
                if let movieImage = image {
                    DispatchQueue.main.async {
                       cell?.movieImage.image = movieImage
                        cell?.setNeedsLayout()

                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: MMSegueIdentifiers.movieDetail, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
