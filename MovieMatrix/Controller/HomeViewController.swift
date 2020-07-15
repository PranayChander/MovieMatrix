//
//  HomeViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 09/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var count = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = MovieCollectionViewLayout()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCollectionViewCell
        return cell!
    }
    
//    func performUpdates() {
//        collectionView.performBatchUpdates({
//            count -= 1
//            collectionView.deleteItems(at: [IndexPath(item: 1, section: 0)])
//            count += 1
//            collectionView.insertItems(at: [IndexPath(item: 4, section: 0)])
//            collectionView.moveItem(at: IndexPath(item: 4, section: 0), to: IndexPath(item: 3, section: 0))
//        }, completion: nil)
//    }
    
}
