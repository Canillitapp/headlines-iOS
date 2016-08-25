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
    
    var data: [String : AnyObject]?
    
    @IBOutlet var trendingTable: WKInterfaceTable!

    func requestTrendingTopicsWithDate (date: NSDate,
                                        success: ((result: [String : AnyObject]?) -> ())?,
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
            
            var res = [String : AnyObject]()
            res["keywords"] = json["keywords"].arrayValue.map {$0.string!}
            
            var topics = [String : [News]]()
            for (k, t) in json["news"] {
                var a = [News]()
                
                for (_, n) in t {
                    let news = News(json: n)
                    a.append(news)
                }
                topics[k] = a
            }
            res["news"] = topics
            
            success?(result: res)
        })

        // do whatever you need with the task e.g. run
        task.resume()

    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        super.willActivate()
        requestTrendingTopicsWithDate(NSDate(), success: { (result) in
            self.data = result
            
            guard let keywords = self.data?["keywords"] as? [String] else {
                return
            }
            
            self.trendingTable.setNumberOfRows(keywords.count, withRowType: "TrendingRow")
            
            for (index, topic) in keywords.enumerate() {
                let row = self.trendingTable.rowControllerAtIndex(index) as! TrendingRowController
                row.titleLabel.setText(topic)
            }
            }, fail: nil)
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        guard let key = self.data?["keywords"]?[rowIndex] as? String,
            news = self.data?["news"]?[key] as? [News] else {
            return
        }
        
        let context = ["title" : key, "elements" : news]
        pushControllerWithName("News", context: context)
    }

}
