//
//  SearchViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var tableView: UITableView!
    
    private var movies = [Movie]()
    private var selectedIndex = 0
    private var currentSessionTask: URLSessionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerTableViewCell(withIdentifier: MMTableViewCellIdentifiers.searchCell)
        tableView.tableFooterView = UIView()
    }
    
    func presentDetailViewController() {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail") as! MovieDetailViewController
        detailVC.movie = movies[selectedIndex]
        present(detailVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSessionTask?.cancel()
        currentSessionTask = MMNetworkClient.getSearchList(query: searchText, completion: { (movies, error) in
            self.movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellIdentifiers.searchTableCell) as? SearchMovieTableViewCell
    //        let movie = movies[indexPath.row]
    //        cell?.movieName.text? = movie.title
    //        cell?.releaseDate.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: movie.releaseDate)
    //        cell?.ratingIndicator.setProgress(value: movie.voteAverage / 10.0)
    //        if let posterPath = movie.posterPath {
    //            MMNetworkClient.getMovieImage(imageName: posterPath) { (image, error) in
    //                if let movieImage = image {
    //                    DispatchQueue.main.async {
    //                        cell?.movieImage?.image = movieImage
    //                        cell?.setNeedsLayout()
    //                    }
    //                }
    //            }
    //        }
    //        return cell!
    //    }
    
    
    // Using Combine
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MMTableViewCellIdentifiers.searchCell) as! SearchMovieTableViewCell
        let movie = movies[indexPath.row]
        cell.movieName.text? = movie.title
        if !movie.releaseDate.isEmpty {
            cell.releaseDate.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: movie.releaseDate)
        }
        cell.ratingIndicator.setProgress(value: movie.voteAverage / 10.0)
        
        var urlRequest = URLRequest(url: MMNetworkClient.Endpoints.getMovieImage(movie.posterPath ?? "").url)
        urlRequest.allowsConstrainedNetworkAccess = false
        cell.subscriber = URLSession.shared.dataTaskPublisher(for: urlRequest).tryCatch({ (error) -> URLSession.DataTaskPublisher in
            guard error.networkUnavailableReason == .constrained else {
                throw error
            }
            // return a task with lower resolution image
            return  URLSession.shared.dataTaskPublisher(for: urlRequest)
        })
            .tryMap({ (data, response) -> UIImage in
                guard let image = UIImage(data: data) else {
                    throw MMError.unknown
                }
                return image
                
            })
            .retry(1)
            .replaceError(with: UIImage(systemName: "paperplane.fill"))
            .receive(on: DispatchQueue.main)
            .assign(to: \.movieImage.image, on: cell)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        presentDetailViewController()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

