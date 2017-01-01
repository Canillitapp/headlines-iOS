//
//  RecentNewsViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 12/9/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class RecentNewsViewController: UITableViewController {

    let newsService = NewsService()
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsService.requestRecentNewsWithDate(Date(), success: { (result) in
            
            guard let r = result else {
                return
            }
            
            self.news.append(contentsOf: r)
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(":-(")
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let n = news[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = n.title
        cell.sourceLabel.text = n.source
        
        if let date = n.date {
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .short
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: date)
        }
        
        if let imgUrl = n.imageUrl {
            cell.newsImageView.isHidden = false
            cell.newsImageView.sd_setImage(with: imgUrl, completed: nil)
        } else {
            cell.newsImageView.isHidden = true
        }
        
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
}
