//
//  TrendingInterfaceController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import WatchKit
import Foundation

class TrendingInterfaceController: WKInterfaceController {
    
    var topics: [Topic]?
    var lastFetch: Date?
    let newsService = NewsService()
    
    @IBOutlet var loadingImageView: WKInterfaceImage!
    @IBOutlet var trendingTable: WKInterfaceTable!
    
    func showLoadingIndicator(_ show: Bool) {
        if show {
            loadingImageView.setHidden(false)
            loadingImageView.setImageNamed("Activity")
            loadingImageView.startAnimatingWithImages(in: NSMakeRange(1, 15), duration: 1, repeatCount: 0)
        } else {
            self.loadingImageView.stopAnimating()
            self.loadingImageView.setHidden(true)
        }
    }
    
    func fetchTrendingNews() {
        showLoadingIndicator(true)
        newsService.requestTrendingTopicsWithDate(Date(), count: 3, success: { (result) in
            self.topics = result
            
            guard let topics = self.topics else {
                return
            }
            
            self.trendingTable.setNumberOfRows(topics.count, withRowType: "TrendingRow")
            
            for (index, t) in topics.enumerated() {
                let row = self.trendingTable.rowController(at: index) as! TrendingRowController
                row.titleLabel.setText(t.name)
            }
            self.showLoadingIndicator(false)
            self.lastFetch = Date()
            }, fail: nil)
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
        
        var shouldUpdate = false
        
        if topics == nil {
            shouldUpdate = true
        } else if let lf = lastFetch {
            let timeInterval = Date().timeIntervalSince(lf)
            if timeInterval > 150 {
                // 2.5 minutes
                shouldUpdate = true
            }
        }
        
        if shouldUpdate {
            fetchTrendingNews()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {        
        guard let t = topics?[rowIndex] else {
            return
        }
        
        let context: [String : Any] = ["title" : t.name ?? "Topic", "elements" : t.news as Any]
        pushController(withName: "News", context: context)
    }

}
