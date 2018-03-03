//
//  FilterSourcesDataSource.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 03/03/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FilterSourcesDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var collectionView: UICollectionView?
    
    var sources: [String]
    var preSelectedSources: [String]
    var selectedSources = [String]()
    
    init(sources: [String], preSelectedSources: [String]) {
        self.sources = sources
        self.preSelectedSources = preSelectedSources
        super.init()
    }
    
    class func sources(fromNews news: [News]) -> [String] {
        var list = news.filter({$0.source != nil}).map({$0.source!})
        list = Array(Set(list))
        return list.sorted(by: { $0.lowercased() < $1.lowercased() })
    }
    
    class func preSelectedSources(fromNewsViewModels viewModels: [NewsCellViewModel]) -> [String] {
        var list = viewModels.map({$0.source}) as! [String]
        list = Array(Set(list))
        return list
    }
    
    func markSelectedCellsFromSources(_ arrayOfSources: [String]?) {
        guard let s = arrayOfSources else {
                return
        }
        
        for aSource in s {
            guard let index = sources.index(of: aSource) else {
                continue
            }
            
            let indexPath = IndexPath(item: index, section: 0)
            collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
        }
    }
    
    func setupSelectedCells() {
        let copyFromArray = preSelectedSources.count == 0 ? sources : preSelectedSources
        
        selectedSources.removeAll()
        selectedSources.append(contentsOf: copyFromArray)
        markSelectedCellsFromSources(selectedSources)
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sources.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! FilterCollectionViewCell
        
        cell.titleLabel.text = sources[indexPath.row]
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
        let selected = sources[indexPath.row]
        selectedSources.append(selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselected = sources[indexPath.row]
        
        guard let deselectedIndex = selectedSources.index(of: deselected) else {
                return
        }
        
        selectedSources.remove(at: deselectedIndex)
    }
}
