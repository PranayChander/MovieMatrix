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
        case nowShowing, genres, topRated, popular, upcoming
        
        var cellHeight: CGFloat {
            var height: CGFloat = 0
            switch self {
            case .nowShowing:
                height = 240
            case .genres:
                height = 100
            case .topRated:
                height = 220
            case .popular:
                height = 220 - 25
            case .upcoming:
                height = 40 + (3 * 75) + 10
            }
            return height
        }
    }
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        switch indexPath.section {
        case 0:
            let cell: MovieWideCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            cell.updateCollection()
            return cell
        case 1:
            let cell: MovieCategoryCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            return cell
        case 2:
            let cell: MovieRegularCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            cell.type = .TopRated
            return cell
        case 3:
            let cell: MovieRegularCollectionViewCellWithCollectionView = collectionView.MMDequeueReusableCell(for: indexPath)
            cell.type = .Popular
            return cell
        case 4:
            let cell: MovieListCollectionViewCellWithTableView = collectionView.MMDequeueReusableCell(for: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: HomeSections(rawValue: indexPath.section)!.cellHeight)
    }
}
