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
    var filterCategoriesDataSource: FilterCategoriesDataSource?
    
    @IBOutlet weak var sourcesCollectionView: DynamicHeightCollectionView!
    @IBOutlet weak var categoriesCollectionView: DynamicHeightCollectionView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    
    func setupSourcesCollectionView() {
        sourcesCollectionView.layer.cornerRadius = 10
        sourcesCollectionView.allowsMultipleSelection = true
        
        filterSourcesDataSource?.collectionView = sourcesCollectionView
        sourcesCollectionView.dataSource = self.filterSourcesDataSource
        sourcesCollectionView.delegate = self.filterSourcesDataSource
        
        sourcesCollectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func setupCategoriesCollectionView() {
        categoriesCollectionView.layer.cornerRadius = 10
        
        filterCategoriesDataSource?.collectionView = categoriesCollectionView
        categoriesCollectionView.dataSource = self.filterCategoriesDataSource
        categoriesCollectionView.delegate = self.filterCategoriesDataSource
        
        categoriesCollectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.layer.cornerRadius = 10
        
        setupSourcesCollectionView()
        setupCategoriesCollectionView()
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
