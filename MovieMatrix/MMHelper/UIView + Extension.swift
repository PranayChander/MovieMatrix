//
//  UIView + Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

extension UIView {
    enum AnchorConstraint {
        case superview(CGFloat)
        case superviewMargin(CGFloat)
    }
    
    func constrain(leadingAnchor: AnchorConstraint, trailingAnchor: AnchorConstraint, topAnchor: AnchorConstraint, bottomAnchor: AnchorConstraint) {
        guard let superview = self.superview else {
            fatalError("SuperView can't be nil")
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        switch leadingAnchor {
        case .superview(let constant):
            constraints.append(self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant))
        case .superviewMargin(let constant) :
            constraints.append(self.layoutMarginsGuide.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant))
        }
        switch trailingAnchor {
        case .superview(let constant):
            constraints.append(self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant))
        case .superviewMargin(let constant) :
            constraints.append(self.layoutMarginsGuide.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant))
        }
        switch topAnchor {
        case .superview(let constant):
            constraints.append(self.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant))
        case .superviewMargin(let constant) :
            constraints.append(self.layoutMarginsGuide.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant))
        }
        switch bottomAnchor {
        case .superview(let constant):
            constraints.append(self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant))
        case .superviewMargin(let constant) :
            constraints.append(self.layoutMarginsGuide.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func constrainToSuperview(leadingConstant leading: CGFloat = 0.0, trailingConstant trailing: CGFloat = 0.0, topConstant top: CGFloat = 0.0, bottomConstant bottom: CGFloat = 0.0) {
        self.constrain(leadingAnchor: .superview(leading), trailingAnchor: .superview(trailing), topAnchor: .superview(top), bottomAnchor: .superview(bottom))
    }
    
    func constrainToSuperviewMargins(leadingConstant leading: CGFloat = 0.0, trailingConstant trailing: CGFloat = 0.0, topConstant top: CGFloat = 0.0, bottomConstant bottom: CGFloat = 0.0) {
        self.constrain(leadingAnchor: .superviewMargin(leading), trailingAnchor: .superviewMargin(trailing), topAnchor: .superviewMargin(top), bottomAnchor: .superviewMargin(bottom))
    }
}
