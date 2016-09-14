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

    private func setupCollectionView() {
        guard let layout = self.collectionView?.collectionViewLayout as? EBCardCollectionViewLayout else {
            return
        }
        
        layout.offset = UIOffset(horizontal: 30, vertical: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        newsService.requestTrendingTopicsWithDate(NSDate(), count:5, success: { (result) in
            guard let keywords = result?["keywords"] as? [String],
                news = result?["news"] as? [String : [News]] else {
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
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywords.count
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? KeywordCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let keyword = self.keywords[indexPath.row]
        cell.titleLabel.text = keyword
        return cell
    }
}
