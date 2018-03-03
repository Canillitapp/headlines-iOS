//
//  FilterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController,
                            UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UIGestureRecognizerDelegate {
    
    var news: [News]?
    
    var sources: [String]?
    var preSelectedSources: [String]?
    var selectedSources = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    
    func generateSourcesList() -> [String] {
        guard let n = news else {
            return []
        }
        
        var differentSources: [String] = n.filter({$0.source != nil}).map({$0.source!})
        differentSources = Array(Set(differentSources))
        return differentSources.sorted(by: { $0.lowercased() < $1.lowercased() })
    }
    
    func markSelectedCellsFromSources(_ arrayOfSources: [String]?) {
        guard let s = arrayOfSources,
            let allSources = sources else {
            return
        }
        
        for aSource in s {
            guard let index = allSources.index(of: aSource) else {
                continue
            }
            
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    func setupSelectedCells() {
        guard let s = preSelectedSources else {
            selectedSources.removeAll()
            selectedSources.append(contentsOf: sources!)
            markSelectedCellsFromSources(sources)
            return
        }
        
        selectedSources.removeAll()
        selectedSources.append(contentsOf: s)
        markSelectedCellsFromSources(selectedSources)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sources = generateSourcesList()
        
        filterButton.layer.cornerRadius = 10
        
        collectionView.layer.cornerRadius = 10
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSelectedCells()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let n = sources?.count else {
            return 0
        }
        
        return n
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! FilterCollectionViewCell
        
        guard let s = sources else {
            return cell
        }
        
        cell.titleLabel.text = s[indexPath.row]
        cell.layer.cornerRadius = 8
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath)
        return headerView
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selected = sources?[indexPath.row] else {
            return
        }
        selectedSources.append(selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let deselected = sources?[indexPath.row],
            let deselectedIndex = selectedSources.index(of: deselected) else {
            return
        }

        selectedSources.remove(at: deselectedIndex)
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if containerStackView.frame.contains(touch.location(in: self.view)) {
            return false
        }
        return true
    }
}
