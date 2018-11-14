//
//  FilterCategoriesDataSource.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 03/03/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FilterCategoriesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var selectedCategory: String?
    var categories: [String]
    weak var collectionView: UICollectionView?
    weak var viewController: UIViewController?
    
    class func categories(fromNews news: [News]) -> [String] {
        var list = news.filter({$0.category != nil}).map({$0.category!})
        list = Array(Set(list))
        list = list.sorted(by: { $0.lowercased() < $1.lowercased() })
        list.append("Todos")
        return list
    }
    
    init(withCategories categories: [String]) {
        self.categories = categories
        super.init()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! LabelCollectionViewCell
        
        cell.label.text = categories[indexPath.row]
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
        selectedCategory = categories[indexPath.row] == "Todos" ? nil : categories[indexPath.row]
        viewController?.performSegue(withIdentifier: "categorySelected", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        return LabelCollectionViewCell.size(with: categories[indexPath.row])
    }
}
