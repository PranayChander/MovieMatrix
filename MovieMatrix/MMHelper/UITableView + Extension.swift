//
//  UITableView + Extension.swift
//  MovieMatrix
//
//  Created by pranay chander on 14/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
extension UITableView {
    func registerTableViewCell(withIdentifier identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
