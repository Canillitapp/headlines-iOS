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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let success: ([Topic]?) -> Void = { [unowned self] (topics) in
            var items = topics
            
            items?.sort(by: { (topicA, topicB) -> Bool in
                guard
                    let newsA = topicA.news,
                    let newsB = topicB.news else {
                    return true
                }
                
                return newsA.count > newsB.count
            })
            
            let itemsTitles = items?.map({ (aTopic) -> String in
                let topicReactionEmoji = aTopic.representativeReaction?.reaction ?? ""
                let topicTitle = aTopic.name?.lowercased() ?? "nil_topic"
                let title = "\(topicTitle) \(topicReactionEmoji) (\(aTopic.news?.count ?? 0))"
                return title
            })
            
            let maxElements = min(3, itemsTitles?.count ?? 0)
            guard let text = itemsTitles?[0..<maxElements].joined(separator: "\n") else {
                return
            }
            
            self.widgetLabel.text = text
        }
        
        newsDataTask = newsService.requestTrendingTopicsWithDate(
            Date(),
            count: 6,
            success: success,
            fail: nil
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
