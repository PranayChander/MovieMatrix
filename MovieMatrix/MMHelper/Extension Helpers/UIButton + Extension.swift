//
//  UIButton + Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension UIButton {
    func toggle(enabled: Bool) {
        tintColor = enabled ? .systemRed : .systemBlue
    }
}
