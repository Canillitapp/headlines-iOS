//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import SwiftyJSON

class NewsService: HTTPService {
    
    func requestPopularNews (success: ((_ result: [News]?) -> Void)?,
                             fail: ((_ error: NSError) -> Void)?) {

        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
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
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-popular",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        _ = request(method: .GET, path: "popular", params: nil, success: successBlock, fail: failBlock)
    }
    
    func requestRecentNewsWithDate (_ date: Date,
                                    success: ((_ result: [News]?) -> Void)?,
                                    fail: ((_ error: NSError) -> Void)?) {

        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)

        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
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
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-recent",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        _ = request(method: .GET, path: "latest/\(datePath)", params: nil, success: successBlock, fail: failBlock)
    }
    
    func requestTrendingTopicsWithDate (_ date: Date,
                                        count: Int,
                                        success: ((_ result: [Topic]?) -> Void)?,
                                        fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask? {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
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
            
            res.sort(by: { (a, b) -> Bool in
                guard let dateA = a.news?.first?.date, let dateB = b.news?.first?.date else {
                    return false
                }
                
                return dateA.compare(dateB) == .orderedDescending
            })
            
            DispatchQueue.main.async(execute: {
                success?(res)
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-trending",
                                    success: successBlock,
                                    fail: failBlock)
            return nil
        }
        
        return request(method: .GET,
                       path: "trending/\(datePath)/\(count)",
                       params: nil,
                       success: successBlock,
                       fail: failBlock)!
    }
    
    func searchNews(_ text: String, success: ((_ result: [News]?) -> Void)?, fail: ((_ error: NSError) -> Void)?) {
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
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
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        _ = request(method: .GET, path: "search/\(encodedText)", params: nil, success: successBlock, fail: failBlock)
    }
}
