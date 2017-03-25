//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController, NewsTableViewCellDelegate {

    var news: [News] = []

    //  MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let item = news[indexPath.row]
        cell.titleLabel.text = item.title
        cell.sourceLabel.text = item.source
        
        if let date = item.date {
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: date)
        }
        
        if let imgUrl = item.imageUrl {
            cell.newsImageView.isHidden = false
            cell.newsImageView.sd_setImage(with: imgUrl, completed: nil)
        } else {
            cell.newsImageView.isHidden = true
        }
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //  MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = news[indexPath.row]
        if let url = n.url {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        }
    }
    
    //  MARK: NewsTableViewCellDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = news.first?.reactions?.count else {
            return 0
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionCell", for: indexPath)
        cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor
        
        if let c = cell as? ReactionCollectionViewCell {
            if let r = news.first?.reactions?[indexPath.row] {
                c.reactionLabel.text = "\(r.reaction) \(r.amount)"
            }
        }
        
        return cell
    }
}
