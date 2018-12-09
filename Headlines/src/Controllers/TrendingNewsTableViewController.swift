//
//  TrendingNewsTableViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 08/12/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TrendingNewsTableViewController: NewsTableViewController {

    var topic: Topic?
    var topicHeaderViewModel: TopicHeaderViewModel?
    
    private func setupTopicHeaderView() {
        
        guard
            let tableView = tableView,
            let topic = topic else {
                
                return
        }
        
        topicHeaderViewModel = TopicHeaderViewModel(topic: topic)
        guard let topicHeaderViewModel = topicHeaderViewModel else {
            return
        }
        
        // Get header view
        let headerNib = UINib(nibName: "TopicHeaderView", bundle: nil)
        guard let headerView = headerNib.instantiate(withOwner: self, options: nil).first as? TopicHeaderView else {
            return
        }
        
        headerView.autoresizingMask = .flexibleWidth
        headerView.dateLabel.text = topicHeaderViewModel.dateString
        headerView.titleLabel.text = topicHeaderViewModel.title
        headerView.quantityLabel.text = topicHeaderViewModel.quantity
        
        let newsWithImages = news.filter({$0.imageUrl != nil})
        guard let image = newsWithImages.first?.imageUrl else {
            return
        }
        headerView.backgroundImageView.sd_setImage(with: image, completed: nil)
        
        tableView.tableHeaderView = headerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopicHeaderView()
    }
}
