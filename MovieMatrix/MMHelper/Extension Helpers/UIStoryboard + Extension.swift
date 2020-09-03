//
//  UIStoryboard + Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func getVC(storyboard: StoryboardType, viewControllerIdentifier: ViewController) -> UIViewController {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(identifier: viewControllerIdentifier.rawValue)
    }
}
