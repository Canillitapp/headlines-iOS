//
//  TodayViewController.swift
//  Canillitapp Widget
//
//  Created by Ezequiel Becerra on 26/11/2017.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    var newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    
    @IBOutlet weak var widgetLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var todayViewModel = TodayViewModel()
    
    private func showActivity(_ showActivity: Bool) {
        if showActivity {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        widgetLabel.isHidden = showActivity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity(true)
        
        let success: ([Topic]?) -> Void = { [unowned self] (topics) in
            self.showActivity(false)
            
            var items = topics
            
            items?.sort(by: { (topicA, topicB) -> Bool in
                guard
                    let newsA = topicA.news,
                    let newsB = topicB.news else {
                    return true
                }
                
                return newsA.count > newsB.count
            })
            
            self.todayViewModel.topics = items

            guard let attributedText = self.todayViewModel.attributedTitlesString else {
                return
            }

            self.widgetLabel.attributedText = attributedText
        }
        
        let fail: (NSError) -> Void = { [unowned self] (error) in
            self.showActivity(false)
        }
        
        newsDataTask = newsService.requestTrendingTopicsWithDate(
            Date(),
            count: 6,
            success: success,
            fail: fail
        )
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
