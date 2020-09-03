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
    
    enum Section: CaseIterable {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, Movie>!
    
    private var movies = [Movie]()
    
    private var currentSessionTask: URLSessionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.MMRegister(SearchMovieTableViewCell.self)
        tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.configureDataSource()
        self.updateUI()
    }
    
    func presentDetailViewController(selectedMovie: Movie) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "movieDetail") as! MovieDetailViewController
        detailVC.movie = selectedMovie
        present(detailVC, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSessionTask?.cancel()
        currentSessionTask = MMNetworkClient.getSearchList(query: searchText, completion: { (movies, error) in
            self.movies = movies
            self.updateUI()
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

// Tableview Implementation with Diffable DataSource
extension SearchViewController {
    func updateUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapShot.appendSections([.main])
        snapShot.appendItems(movies)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView, cellProvider: { (tableView, indexPath, movie) -> UITableViewCell? in
            let cell: SearchMovieTableViewCell = tableView.MMDequeueReusableCell(for: indexPath)
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
        })
    }
}

extension SearchViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = dataSource.itemIdentifier(for: indexPath) {
            presentDetailViewController(selectedMovie: selectedMovie)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

