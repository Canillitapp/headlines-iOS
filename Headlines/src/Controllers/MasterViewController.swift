//
//  MasterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import EBCardCollectionViewLayout

class MasterViewController: UICollectionViewController {

    var keywords = [String]()
    var news = [String : [News]]()
    let newsService = NewsService()

    fileprivate func setupCollectionView() {
        guard let layout = self.collectionView?.collectionViewLayout as? EBCardCollectionViewLayout else {
            return
        }
        
        layout.offset = UIOffset(horizontal: 30, vertical: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        newsService.requestTrendingTopicsWithDate(Date(), count:5, success: { (result) in
            guard let keywords = result?["keywords"] as? [String],
                let news = result?["news"] as? [String : [News]] else {
                return
            }
            
            self.keywords = keywords
            self.news = news
            self.collectionView?.reloadData()
            
            }, fail: { (error) in
                print(error.localizedDescription)
            })
    }

    // MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywords.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as? KeywordCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let keyword = self.keywords[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = keyword
        return cell
    }
}
