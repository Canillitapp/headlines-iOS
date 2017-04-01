//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UITableViewController {

    var news: [News] = [] {
        didSet {
            news.forEach({ (n) in
                let viewModel = NewsCellViewModel(news: n)
                newsViewModels.append(viewModel)
            })
        }
    }
    
    var newsViewModels: [NewsCellViewModel] = []

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
        
        let viewModel = newsViewModels[indexPath.row]
        
        cell.titleLabel.text = viewModel.title
        cell.sourceLabel.text = viewModel.source
        cell.timeLabel.text = viewModel.timeString
        cell.reactionsDataSource = viewModel
        cell.reactionsDelegate = viewModel
        
        if let imgURL = viewModel.imageURL {
            cell.newsImageView.isHidden = false
            cell.newsImageView.sd_setImage(with: imgURL, completed: nil)
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
