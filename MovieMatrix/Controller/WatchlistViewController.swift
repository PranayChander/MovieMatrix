//
//  WatchlistViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SearchMovieTableViewCell", bundle: nil), forCellReuseIdentifier: MMTableViewCellIdentifiers.searchTableCell)
        tableView.tableFooterView = UIView()
        _ = MMNetworkClient.getWatchlist() { movies, error in
            MovieModel.watchlist = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.movie = MovieModel.watchlist[selectedIndex]
        }
    }
    
}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieModel.watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellIdentifiers.searchTableCell) as? SearchMovieTableViewCell
        let movie = MovieModel.watchlist[indexPath.row]
        cell?.movieName.text? = movie.title
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
}
