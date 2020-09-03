//
//  FavoritesViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

//MARK:- Using Diffiable DataSource
import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    
    private var dataSource: UITableViewDiffableDataSource<Int, UserMovie>!
    private var selectedMovie: UserMovie?
    
    lazy var fetchedResultsController: NSFetchedResultsController<UserMovie> = {
        let fetchRequest = UserMovie.fetchMovieRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending:true)]
        let watchlistPredicate = NSPredicate(format: "isFavorite==%d", true)
        fetchRequest.predicate = watchlistPredicate

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: MMPersistentStore.sharedInstance.mainManagedObjectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.MMRegister(SearchMovieTableViewCell.self)
        tableView.tableFooterView = UIView()
        self.configureDataSource()
        self.updateUI()
        FavoritesAPIService.performNetworkService(request: FavoritesNetworkRequest()) { (_) in}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MMSegueIdentifiers.movieDetail {
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.userMovie = selectedMovie
        }
    }
}

// Tableview Implementation with Diffable DataSource
extension FavoritesViewController {
    func updateUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, UserMovie>()
        snapShot.appendSections([0])
        snapShot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        dataSource.apply(snapShot)
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, UserMovie>(tableView: tableView, cellProvider: { (tableView, indexPath, movie) -> UITableViewCell? in
        
            let cell: SearchMovieTableViewCell = tableView.MMDequeueReusableCell(for: indexPath)
            cell.movieName.text = movie.title
            cell.releaseDate.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: movie.releaseDate ?? "01/01/2020")
            cell.ratingIndicator.setProgress(value: movie.voteAverage / 10.0)
            if let posterPath = movie.posterPath {
                MMNetworkClient.getMovieImage(imageName: posterPath) { (image, error) in
                    if let movieImage = image {
                        DispatchQueue.main.async {
                            cell.movieImage.image = movieImage
                        }
                    }
                }
            }
            return cell
        })
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectMovie = dataSource.itemIdentifier(for: indexPath) {
            selectedMovie = selectMovie
            performSegue(withIdentifier: MMSegueIdentifiers.movieDetail, sender: self)
        }
    }
}

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateUI()
    }
}
