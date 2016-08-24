//
//  TrendingInterfaceController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON

class TrendingInterfaceController: WKInterfaceController {
    
    var topics: [String]?
    
    @IBOutlet var trendingTable: WKInterfaceTable!

    func requestTrendingTopicsWithDate (date: NSDate,
                                        success: ((keywords: [String]?) -> ())?,
                                        fail: ((error: NSError) -> ())?) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year, components.month, components.day)
        
        let url = NSURL(string: "http://45.55.247.52:4567/trending/\(datePath)")
        let request = NSURLRequest(URL: url!)

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)

        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if let e = error {
                fail?(error: e)
                return
            }

            guard let d = data else {
                return
            }
            
            let json = JSON(data: d)
            success?(keywords: json["keywords"].arrayValue.map { $0.string!})
        })

        // do whatever you need with the task e.g. run
        task.resume()

    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        requestTrendingTopicsWithDate(NSDate(), success: { (keywords) in
            self.topics = keywords
            
            guard let t = self.topics else {
                return
            }
            
            self.trendingTable.setNumberOfRows(t.count, withRowType: "TrendingRow")
            
            for (index, topic) in t.enumerate() {
                let row = self.trendingTable.rowControllerAtIndex(index) as! TrendingRowController
                row.titleLabel.setText(topic)
            }
        }, fail: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
