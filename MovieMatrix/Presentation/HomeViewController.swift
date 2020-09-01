//
//  HomeViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    enum HomeSections: Int, CaseIterable {
        case NowShowing, Genres, TopRated, Popular, Upcoming
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.collectionViewLayout = MovieCollectionViewLayout()
        registerCollectionViewCells()
        
        NowShowingAPIService.performNetworkService(request: NowShowingNetworkRequest()) { (Response) in
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    private func registerCollectionViewCells() {
        self.collectionView.MMRegister(MovieWideCollectionViewCellWithCollectionView.self)
        self.collectionView.MMRegister(MovieCategoryCollectionViewCellWithCollectionView.self)
        self.collectionView.MMRegister(MovieRegularCollectionViewCellWithCollectionView.self)
        self.collectionView.MMRegister(MovieListCollectionViewCellWithTableView.self)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: MovieWideCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
                cell.updateCollection()
            return cell
        } else if indexPath.section == 1 {
            let cell: MovieCategoryCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            return cell
        } else if indexPath.section == 2 {
            let cell: MovieRegularCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            cell.type = .TopRated
        return cell
        }
        else if indexPath.section == 3 {
            let cell: MovieRegularCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            cell.type = .Popular
        return cell
        }
        else {
            let cell: MovieListCollectionViewCellWithTableView = collectionView.MMDequeueReusableCell(for: indexPath)
        return cell
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: self.view.frame.width, height: 240)
        } else if indexPath.section == 1 {
            return CGSize(width: self.view.frame.width, height: 100)
        } else if indexPath.section == 2 {
            return CGSize(width: self.view.frame.width, height: 220)
        } else if indexPath.section == 3 {
            return CGSize(width: self.view.frame.width, height: 220 - 25 )
        } else {
            return CGSize(width: self.view.frame.width, height: 40 + (3 * 75) + 10)
        }
    }
}
