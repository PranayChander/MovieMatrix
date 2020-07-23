//
//  ProfileViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var MovieRatingView: MovieRatingView!
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MMUtilities.sharedInstance.logMessage("Profile Screen Visited")
        ProfileDetailAPIService.performNetworkService(request: ProfileDetailsRequest()) { (response) in
            print(response)
        }
        MMNetworkClient.performMMSessionNetworkRequest()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
    }
    
    @objc private func animate() {
        MovieRatingView.setProgress(value: 0.8, withAnimation: true, duration: 3)
        self.present(overlay: .banner(BannerViewModel(title: "A Demo for Banner View", body: "This is similiar to the notification banner in iOS , can be used for sudden alert")))
    }
}
