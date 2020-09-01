//
//  ProfileViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var MovieRatingView: MovieRatingView!
    
    
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var fName: UILabel!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    let shapeLayer = CAShapeLayer()
    
    lazy var fetchedResultsController: NSFetchedResultsController<UserProfile> = {
        let fetchRequest = NSFetchRequest<UserProfile>(entityName:"UserProfile")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userId", ascending:true)]

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
        fetchedResultsController.delegate = self
        setupLabels()
//        MMUtilities.sharedInstance.logMessage("Profile Screen Visited")
        ProfileDetailAPIService.performNetworkService(request: ProfileDetailsRequest()) { (response) in
            print(response)
        }
//        MMNetworkClient.performMMSessionNetworkRequest()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
    }
    
    func setupLabels() {
        if let user = fetchedResultsController.fetchedObjects?.first {
        userID.text = "\(user.userId)"
        fName.text = user.firstName
        lName.text = user.lastName
        mobileNumber.text = user.phoneNumber
        city.text = user.city
        country.text = user.country
        status.text = user.status
        }
    }
    
    @objc private func animate() {
        MovieRatingView.setProgress(value: 0.8, withAnimation: true, duration: 3)
        self.present(overlay: .banner(BannerViewModel(title: "A Demo for Banner View", body: "This is similiar to the notification banner in iOS , can be used for sudden alert")))
    }
}

extension ProfileViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        setupLabels()
    }
    
}
