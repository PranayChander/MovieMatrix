//
//  MMTabBarController.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MMTabBarController: UITabBarController, NetworkServiceDelegate {
    private var networkStatusMessageView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusMessage(notif:)), name: MMAlamofireNetworkService.NetworkReachablityStatus, object: nil)
        MMAlamofireNetworkService.sharedInstance.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func presentNetworkStatusMessage() {
        let offlineMessage = "You are currently Offline"
        let textHeight = offlineMessage.heightWithConstrainedWidth(self.view.frame.width, font: UIFont.systemFont(ofSize: 20))
        let statusBarMessageHeight = textHeight + 10
        self.networkStatusMessageView = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.height - self.tabBar.frame.height - statusBarMessageHeight, width: self.view.frame.width, height: statusBarMessageHeight))
        self.networkStatusMessageView?.backgroundColor = .red
        
        let networkStatusMessageLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20.0)
            label.numberOfLines = 0
            label.text = offlineMessage
            label.backgroundColor = .red
            return label
        }()
        
        if let offlineMessageView = self.networkStatusMessageView {
            self.view.addSubview(offlineMessageView)
            offlineMessageView.addSubview(networkStatusMessageLabel)
            networkStatusMessageLabel.constrainToSuperview()
        }
    }
    
    @objc private func handleNetworkStatusMessage(notif: Notification) {
        if let reachablity = notif.object as? ReachablityStatus {
            if reachablity != .reachable && self.networkStatusMessageView == nil {
                presentNetworkStatusMessage()
            } else if reachablity == .reachable && self.networkStatusMessageView != nil {
                self.networkStatusMessageView?.removeFromSuperview()
            }
        }
    }
}
