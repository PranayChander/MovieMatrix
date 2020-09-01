//
//  BannerViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension CGFloat {
    static let standardBannerPadding: CGFloat = 20.0
    static let maxBannerWidth: CGFloat = 500.0
    static let minBannerHeight: CGFloat = 80.0
}

extension TimeInterval {
    static let animationDuration = 0.25
    static let lingerTime = 5.0
}

class BannerViewController: OverlayViewController {
    var widthConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    
    override func present(in window: UIWindow) {

        let bannerView = BannerView()
        self.view = bannerView
        
        switch self.overlay {
        case .banner(let viewModel):
            bannerView.configure(with: viewModel)
        }
        self.constrain(bannerView: bannerView, to: window)
        self.animate(bannerView: bannerView, in : window)
        self.addSwipeGesture()
    }
    
    func constrain(bannerView: BannerView, to window: UIWindow) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor: NSLayoutConstraint
        topAnchor = bannerView.topAnchor.constraint(greaterThanOrEqualTo: window.topAnchor, constant: .standardBannerPadding)
        
        self.widthConstraint = bannerView.widthAnchor.constraint(lessThanOrEqualToConstant: .maxBannerWidth)
        self.leadingConstraint = bannerView.leadingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.leadingAnchor, constant: .standardBannerPadding)
        self.trailingConstraint = bannerView.trailingAnchor.constraint(equalTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -.standardBannerPadding)
        
        var constraints: [NSLayoutConstraint] = [
        topAnchor,
        bannerView.heightAnchor.constraint(equalToConstant: .minBannerHeight),
        bannerView.centerXAnchor.constraint(equalTo: window.centerXAnchor)]
        
        let belowNotchAnchor = bannerView.topAnchor.constraint(greaterThanOrEqualTo: window.safeAreaLayoutGuide.topAnchor)
        constraints.append(belowNotchAnchor)
        
        NSLayoutConstraint.activate(constraints)
        self.activateConstraintsForCurrentSizeClass()
    }
    
    func activateConstraintsForCurrentSizeClass() {
        let isCompact = self.traitCollection.horizontalSizeClass == .compact
        self.leadingConstraint?.isActive = isCompact
        self.trailingConstraint?.isActive = isCompact
        self.widthConstraint?.isActive = isCompact
    }
    
    func animate(bannerView: BannerView, in window: UIWindow) {
        bannerView.transform = CGAffineTransform(translationX: 0, y: -bannerView.animationDistance)
        
        UIView.animate(withDuration: .animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            bannerView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .lingerTime) {
            if self.parent != nil {
                self.dismiss(bannerView: bannerView)
            }
        }
    }
    
    func dismiss(bannerView: BannerView) {
        UIView.animate(withDuration: .animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            bannerView.transform = CGAffineTransform(translationX: 0, y: -bannerView.animationDistance)
        }) { _ in
            bannerView.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    func addSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeGesture.direction = .up
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func respondToSwipeGesture(sender: UISwipeGestureRecognizer) {
        if let bannerView = sender.view as? BannerView {
            self.dismiss(bannerView: bannerView)
        }
    }
}
