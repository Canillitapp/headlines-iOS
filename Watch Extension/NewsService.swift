//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsService: NSObject {
    func requestTrendingTopicsWithDate (_ date: Date,
                                        count: Int,
                                        success: ((_ result: [String : Any]?) -> ())?,
                                        fail: ((_ error: NSError) -> ())?) {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)
        
        let url = URL(string: "http://45.55.247.52:4567/trending/\(datePath)/\(count)")
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let e = error {
                fail?(e as NSError)
                return
            }
            
            guard let d = data else {
                return
            }
            
            let json = JSON(data: d)
            
            var res = [String : Any]()
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
            res["news"] = topics as AnyObject?
            
            DispatchQueue.main.async(execute: { 
                success?(res)                
            })
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
}
