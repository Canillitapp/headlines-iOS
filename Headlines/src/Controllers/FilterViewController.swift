//
//  FilterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,
                            UIGestureRecognizerDelegate {
    
    var filterSourcesDataSource: FilterSourcesDataSource?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.layer.cornerRadius = 10
        
        collectionView.layer.cornerRadius = 10
        collectionView.allowsMultipleSelection = true
        
        filterSourcesDataSource?.collectionView = collectionView
        collectionView.dataSource = self.filterSourcesDataSource
        collectionView.delegate = self.filterSourcesDataSource
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filterSourcesDataSource?.setupSelectedCells()
    }
    
    // MARK: UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if containerStackView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
