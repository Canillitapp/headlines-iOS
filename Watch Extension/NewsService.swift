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
    
    func requestRecentNewsWithDate (_ date: Date,
                                    success: ((_ result: [News]?) -> ())?,
                                    fail: ((_ error: NSError) -> ())?) {

        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)
        
        let url = URL(string: "http://45.55.247.52:4567/latest/\(datePath)")
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let e = error {
                DispatchQueue.main.async(execute: {
                    fail?(e as NSError)
                })
                return
            }
            
            guard let d = data else {
                return
            }
            
            let json = JSON(data: d)
            
            var res = [News]()
            
            for (_, v) in json {
                let n = News(json: v)
                res.append(n)
            }
            
            DispatchQueue.main.async(execute: { 
                success?(res)
            })
        })
        
        task.resume()
    }
    
    func requestTrendingTopicsWithDate (_ date: Date,
                                        count: Int,
                                        success: ((_ result: [Topic]?) -> ())?,
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
                DispatchQueue.main.async(execute: {
                    fail?(e as NSError)
                })
                return
            }
            
            guard let d = data else {
                return
            }
            
            let json = JSON(data: d)
            
            var res = [Topic]()
            
            for (k, t) in json["news"] {
                let a = Topic()
                a.name = k
                a.date = date
                a.news = [News]()
                
                for (_, n) in t {
                    let news = News(json: n)
                    a.news!.append(news)
                }
                
                res.append(a)
            }
            
            DispatchQueue.main.async(execute: { 
                success?(res)                
            })
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
    func searchNews(_ text: String, success: ((_ result: [News]?) -> ())?, fail: ((_ error: NSError) -> ())?) {
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let url = URL(string: "http://45.55.247.52:4567/search/\(encodedText)")
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let e = error {
                DispatchQueue.main.async {
                    fail?(e as NSError)
                }
                return
            }
            
            guard let d = data else {
                return
            }
            
            let json = JSON(data: d)
            
            var res = [News]()
            
            for (_, v) in json {
                let n = News(json: v)
                res.append(n)
            }
            
            DispatchQueue.main.async(execute: {
                success?(res)
            })
        })
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
}
