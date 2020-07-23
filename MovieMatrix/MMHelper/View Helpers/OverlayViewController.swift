//
//  OverlayViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

protocol OverlayViewModel {
    var title: String {get}
}

struct BannerViewModel: OverlayViewModel {
    var title: String
    var body: String?
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

enum Overlay {
    case banner(BannerViewModel)
}

class OverlayViewController: UIViewController {
    let overlay: Overlay
    
    init(overlay: Overlay) {
        self.overlay = overlay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present(in window: UIWindow) {
        assertionFailure("This method  needs to be overidden in the subclass")
    }
}
