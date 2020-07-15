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
        // Do any additional setup after loading the view.
        
//        let trackLayer = CAShapeLayer()
//        let trackCenter = view.center
//        let trackPath = UIBezierPath(arcCenter: trackCenter, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//        trackLayer.path = trackPath.cgPath
//        trackLayer.strokeColor = UIColor.black.cgColor
//        trackLayer.fillColor = UIColor.clear.cgColor
//        trackLayer.lineWidth = 12.0
//        view.layer.addSublayer(trackLayer)
//
//        let center = view.center
//        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
//        shapeLayer.path = circularPath.cgPath
//
//        shapeLayer.strokeColor = UIColor.green.cgColor
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineWidth = 10.0
//        shapeLayer.lineCap = .round
//
//        shapeLayer.strokeEnd = 0
//
//
//
//        view.layer.addSublayer(shapeLayer)
//
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
    }
    
    @objc private func animate() {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = .forwards
//        basicAnimation.isRemovedOnCompletion = false
//        shapeLayer.add(basicAnimation, forKey: "ratingAnimation")
        MovieRatingView.setProgress(value: 0.8, withAnimation: true, duration: 3)
        self.present(overlay: .banner(BannerViewModel(title: "sasa", body: "dsldmlk")))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
