//
//  MovieListCollectionViewCellWithTableView.swift
//  MovieMatrix
//
//  Created by pranay chander on 13/08/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class MovieListCollectionViewCellWithTableView: UICollectionViewCell, NibLoadableView {

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.MMRegister(MovieListTableViewCell.self)
    }
}

extension MovieListCollectionViewCellWithTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListTableViewCell = tableView.MMDequeueReusableCell(for: indexPath)
        return cell
    }
}

extension MovieListCollectionViewCellWithTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
