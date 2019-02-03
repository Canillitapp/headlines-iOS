//
//  TrendingNewsTableViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 08/12/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class TrendingNewsTableViewController: NewsTableViewController {

    var headerView: TopicHeaderView?
    var headerViewModel: TopicHeaderViewModel?
    
    let headerViewHeight: CGFloat = 180.0
    var headerViewHeightConstraint: NSLayoutConstraint?
    var headerViewTopConstraint: NSLayoutConstraint?
    
    private func setupTopicHeaderView() {
        
        guard let tableView = tableView else {
            return
        }
        
        tableView.contentInset = UIEdgeInsets(top: headerViewHeight,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        
        tableView.contentOffset = CGPoint(x: 0, y: -headerViewHeight)
        
        headerViewModel = TopicHeaderViewModel(news: news)
        guard let headerViewModel = headerViewModel else {
            return
        }
        
        // Get header view
        let headerNib = UINib(nibName: "TopicHeaderView", bundle: nil)
        guard let headerView = headerNib.instantiate(withOwner: self, options: nil).first as? TopicHeaderView else {
            return
        }
        
        // Set labels and image
        headerView.dateLabel.text = headerViewModel.dateString
        headerView.titleLabel.text = self.title
        headerView.quantityLabel.text = headerViewModel.quantity
        
        let newsWithImages = news.filter({$0.imageUrl != nil})
        guard let image = newsWithImages.first?.imageUrl else {
            return
        }
        headerView.backgroundImageView.sd_setImage(with: image, completed: nil)
        headerView.backgroundColor = UIColor.red
        
        // Constraints
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        let leftConstraint = NSLayoutConstraint(item: headerView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: headerView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        headerViewTopConstraint = topConstraint
        
        let rightConstraint = NSLayoutConstraint(item: headerView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: headerView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1,
                                                  constant: headerViewHeight)
        headerViewHeightConstraint = heightConstraint
        
        view.addConstraints([leftConstraint, topConstraint, rightConstraint, heightConstraint])
        
        self.headerView = headerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            setupTopicHeaderView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.regular {
            return
        }
        
        guard
            let headerViewHeightConstraint = headerViewHeightConstraint,
            let headerViewTopConstraint = headerViewTopConstraint else {
            return
        }
        
        if scrollView.contentOffset.y <= -headerViewHeight {
            let newHeight = abs(scrollView.contentOffset.y + headerViewHeight) + headerViewHeight
            headerViewHeightConstraint.constant = newHeight
            headerViewTopConstraint.constant = 0
            
        } else {
            headerViewTopConstraint.constant = -max(scrollView.contentOffset.y + headerViewHeight, 0)
        }
        
        scrollView.scrollIndicatorInsets.top = headerViewHeightConstraint.constant
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Remove headerview just in case there was another headerview before
        self.headerView?.removeFromSuperview()
        
        if view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact {
            setupTopicHeaderView()
            
        } else {
            // Reset tableView insets to zero that were modified to support headerView
            tableView?.contentInset = .zero
            tableView?.contentOffset = .zero
            tableView?.scrollIndicatorInsets = .zero
        }
    }
}
