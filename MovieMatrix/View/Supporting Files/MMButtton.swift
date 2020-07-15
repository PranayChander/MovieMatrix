//
//  MMButtton.swift
//  MovieMatrix
//
//  Created by pranay chander on 07/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

@IBDesignable
class MMButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
