//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import CloudKit
import SwiftyJSON

// swiftlint:disable force_try
class NewsService: HTTPService {
    
    func requestFromCategory (_ categoryId: String,
                              success: ((_ result: [News]?) -> Void)?,
                              fail: ((_ error: NSError) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let d = data else {
                return
            }
            
            let res = try? News.decodeArrayOfNews(from: d)
            
            DispatchQueue.main.async(execute: {
                success?(res)
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        let path = "news/category/\(categoryId)"
        _ = request(method: .GET, path: path, params: nil, success: successBlock, fail: failBlock)
    }
    
    func requestPopularNews (success: ((_ result: [News]?) -> Void)?,
                             fail: ((_ error: NSError) -> Void)?) {

        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let d = data else {
                return
            }
            
            let res = try? News.decodeArrayOfNews(from: d)
            
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
            
            let res = try? News.decodeArrayOfNews(from: d)
            
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
                                        success: ((_ result: TopicList?) -> Void)?,
                                        fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask? {
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let d = data else {
                return
            }

            let res = try! JSONDecoder().decode(TopicList.self, from: d)

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
    
    func searchNews(_ text: String,
                    success: ((_ result: [News]?) -> Void)?,
                    fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask? {
        
        let group = DispatchGroup()
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let d = data else {
                return
            }
            
            let res = try? News.decodeArrayOfNews(from: d)
            
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
            return nil
        }
        
        var headers: [String: String] = [:]
        
        let container = CKContainer.default()
        group.enter()
        
        container.fetchUserRecordID { (recordId, _) in
            
            /**
             * This is some weird shit.
             * This worked until some backend update and had to replace "user_id" to "user-id"
             * it seems that sending headers with "_" breaks something now.
             *
             * Also, "user-id" translates to "HTTP_USER_ID" on the other side.
             *
             * Related issue: https://github.com/rails/rails/issues/16519
             */
            if let identifier = recordId?.recordName {
                headers["user-id"] = identifier
                headers["user-source"] = "iOS"
            }
            
            group.leave()
        }

        group.wait()
        return self.request(
                        method: .GET,
                        path: "search/\(encodedText)",
                        params: nil,
                        headers: headers,
                        success: successBlock,
                        fail: failBlock
                )
    }
    
    func fetchTrendingTerms(success: ((_ result: [TrendingTerm]) -> Void)?,
                            fail: ((_ error: NSError) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {( data, response) in
            guard let data = data else {
                return
            }

            let terms = (try? JSONDecoder().decode([TrendingTerm].self, from: data)) ?? [TrendingTerm]()

            DispatchQueue.main.async(execute: {
                success?(terms)
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search-trending",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        _ = request(
            method: .GET,
            path: "search/trending/",
            params: nil,
            success: successBlock,
            fail: failBlock
        )
    }
    
    @discardableResult
    func fetchTags(tag: String, success: ((_ result: [Tag]) -> Void)?,
                   fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask? {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {( data, response) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let tags = try? decoder.decode([Tag].self, from: data)
            DispatchQueue.main.async(execute: {
                success?(tags ?? [Tag]())
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search-term",
                                    success: successBlock,
                                    fail: failBlock)
            return nil
        }
        
        let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? String()
        return request(
            method: .GET,
            path: "tags/\(encodedTag)",
            params: nil,
            success: successBlock,
            fail: failBlock
        )
    }
}
