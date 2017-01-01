//
//  MasterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SDWebImage

class MasterViewController: UICollectionViewController {

    var topics = [Topic]()
    let newsService = NewsService()
    
    func requestTrendingTopicsWithDate(_ date: Date) {
        newsService.requestTrendingTopicsWithDate(date, count:3, success: { (result) in
            
            guard let r = result else {
                return
            }
            
            var indexPaths = [IndexPath]()
            let startIndex = self.topics.count
            let endIndex = startIndex + r.count-1
            
            for index in startIndex...endIndex {
                let i = IndexPath(row: index, section: 0)
                indexPaths.append(i)
            }
            
            self.topics.append(contentsOf: r)
            self.collectionView?.insertItems(at: indexPaths)
            
        }, fail: { (error) in
            print(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionViewSize = self.collectionView?.bounds.size else {
            return
        }
        
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSize(width: collectionViewSize.width - 20, height: 260)
        
        requestTrendingTopicsWithDate(Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        if identifier == "news" {
            if let vc = segue.destination as? NewsTableViewController,
                let topic = sender as? Topic,
                let topicName = topic.name,
                let topicNews = topic.news {
                
                vc.title = topicName
                vc.news = topicNews
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let topic = topics[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as? KeywordCollectionViewCell,
            let news = topic.news,
            let firstNews = news.first else {
            return UICollectionViewCell()
        }
        
        if let newsDate = firstNews.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.doesRelativeDateFormatting = true
            cell.dateLabel.text = dateFormatter.string(from: newsDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: newsDate)
        }

        cell.titleLabel.text = topic.name
        cell.bodyLabel.text = firstNews.title
        cell.sourceLabel.text = firstNews.source
        cell.newsQuantityLabel.text = "\(news.count) noticias"
        
        if let imgUrl = firstNews.imageUrl {
            cell.imageView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        performSegue(withIdentifier: "news", sender: topic)
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        if indexPath.row == topics.count-1 {
            let topic = topics[indexPath.row]
            
            guard let lastDate = topic.date else {
                return
            }
            
            let calendar = Calendar.current
            let newDate = calendar.date(byAdding: .day, value: -1, to: lastDate)
            
            requestTrendingTopicsWithDate(newDate!)
        }
    }
}
