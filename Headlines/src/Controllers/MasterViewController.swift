//
//  MasterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {

    var keywords = [String]()
    var news = [String : [News]]()
    let newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionViewSize = self.collectionView?.bounds.size else {
            return
        }
        
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width: collectionViewSize.width - 20, height: 180)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == "news" {
            if let vc = segue.destination as? NewsTableViewController,
                let key = sender as? String,
                let selectedNews = news[key] as [News]? {
                vc.title = key
                vc.news = selectedNews
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywords.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let keyword = self.keywords[(indexPath as NSIndexPath).row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as? KeywordCollectionViewCell,
            let keywordNews = self.news[keyword] as [News]?,
            let firstNews = keywordNews.first else {
            return UICollectionViewCell()
        }
        
        if let newsDate = firstNews.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            cell.dateLabel.text = dateFormatter.string(from: newsDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: newsDate)
        }

        cell.titleLabel.text = keyword
        cell.bodyLabel.text = firstNews.title
        cell.sourceLabel.text = firstNews.source
        cell.newsQuantityLabel.text = "\(keywordNews.count) noticias"
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let keyword = self.keywords[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "news", sender: keyword)
    }
}
