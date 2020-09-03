//
//  WatchlistViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
import CoreData

class WatchlistViewController: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
    private var selectedMovie: UserMovie?
    
    lazy var fetchedResultsController: NSFetchedResultsController<UserMovie> = {
        let fetchRequest = UserMovie.fetchMovieRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending:true)]
        let watchlistPredicate = NSPredicate(format: "isWatchlisted==%d", true)
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
        tableView.MMRegister(SearchMovieTableViewCell.self)
        tableView.tableFooterView = UIView()
        WatchlistAPIService.performNetworkService(request: WatchlistNetworkRequest()) {(_) in }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MMSegueIdentifiers.movieDetail {
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.userMovie = selectedMovie
        }
    }
}

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchMovieTableViewCell = tableView.MMDequeueReusableCell(for: indexPath)
        let movie = fetchedResultsController.object(at: indexPath)
        if let title = movie.title, let releaseDate = movie.releaseDate {
            cell.movieName.text? = title
            cell.releaseDate.text = MMUtilities.sharedInstance.getformattedDateForString(dateString: releaseDate)
        }
        cell.ratingIndicator.setProgress(value: movie.voteAverage / 10.0)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = fetchedResultsController.object(at: indexPath)
        selectedMovie = movie
        performSegue(withIdentifier: MMSegueIdentifiers.movieDetail, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

extension WatchlistViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath, let _ = tableView.cellForRow(at: indexPath) as? SearchMovieTableViewCell {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        @unknown default:
            fatalError(MMError.coreDataError(nil).localizedDescription)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
