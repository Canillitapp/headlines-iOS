//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsService : NSObject {
    func requestTrendingTopicsWithDate (date: NSDate,
                                        count: Int,
                                        success: ((result: [String : AnyObject]?) -> ())?,
                                        fail: ((error: NSError) -> ())?) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year, components.month, components.day)
        
        let url = NSURL(string: "http://45.55.247.52:4567/trending/\(datePath)/\(count)")
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
            
            dispatch_async(dispatch_get_main_queue(), { 
                success?(result: res)                
            })
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
        
    }
}