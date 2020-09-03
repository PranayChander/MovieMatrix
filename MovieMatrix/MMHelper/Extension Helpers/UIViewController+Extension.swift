//
//  UIViewController+Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 08/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(withTitle title: String, withMessage message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: MMStringConstants.OK, style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func present(overlay: Overlay) {
        var overlayVC: OverlayViewController
        switch overlay {
        case .banner:
            overlayVC = BannerViewController(overlay: overlay)
        }
        
        guard let window = self.view.window else {
            print("Enable to get window")
            return
        }
        self.addChild(viewController: overlayVC)
        
        self.willMove(toParent: self)
        self.addChild(overlayVC)
        window.addSubview(overlayVC.view)
        overlayVC.didMove(toParent: self)
        
        overlayVC.present(in: window)
    }
    
    func addChild<ViewController: UIViewController>(viewController: ViewController, onSetup: ((ViewController) -> ())? = nil) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        if let viewSetupBlock = onSetup {
            viewSetupBlock(viewController)
        } else {
            viewController.view.constrainToSuperview()
        }
        viewController.didMove(toParent: self)
    }
}
