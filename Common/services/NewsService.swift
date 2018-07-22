//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import CloudKit

class NewsService: HTTPService {
    
    func requestFromCategory (_ categoryId: Int,
                              success: ((_ result: [News]?) -> Void)?,
                              fail: ((_ error: NSError) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data else {
                return
            }
            let safeNews = try? JSONDecoder().decode([Safe<News>].self, from: data)
            let news = safeNews?.compactMap { $0.value }
            DispatchQueue.main.async(execute: {
                success?(news)
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

        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data else {
                return
            }
            
            let safeNews = try? JSONDecoder().decode([Safe<News>].self, from: data)
            let news = safeNews?.compactMap { $0.value }
            DispatchQueue.main.async(execute: {
                success?(news)
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

        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data else {
                return
            }
            let safeNews = try? JSONDecoder().decode([Safe<News>].self, from: data)
            let news = safeNews?.compactMap { $0.value }
            DispatchQueue.main.async(execute: {
                success?(news)
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
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data  else {
                return
            }
            let topicsResponse = try? JSONDecoder().decode(TopicResponse.self, from: data)
            let topics = topicsResponse?.topics(date: date)
            let orderedTopics = topics?.sorted {
                guard let lhsDate = $0.news?.first?.date,
                    let rhsDate = $1.news?.first?.date else {
                    return false
                }
                return lhsDate < rhsDate
            }
            DispatchQueue.main.async(execute: {
                success?(orderedTopics)
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
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data else {
                return
            }
            let safeNews = try? JSONDecoder().decode([Safe<News>].self, from: data)
            let news = safeNews?.compactMap { $0.value }
            DispatchQueue.main.async(execute: {
                success?(news)
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
            
            if let identifier = recordId?.recordName {
                headers["user_id"] = identifier
                headers["user_source"] = "iOS"
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
    
    func fetchTrendingTerms(success: ((_ result: [TrendingTerm]?) -> Void)?,
                            fail: ((_ error: NSError) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { (data, response) in
            guard let data = data else { return }
            let terms = try? JSONDecoder().decode([TrendingTerm].self,
                                                  from: data)
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
    func fetchTags(tag: String, success: ((_ result: [Tag]?) -> Void)?,
                   fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask? {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = { ( data, response) in
            guard let data = data else { return }
            let tags = try? JSONDecoder().decode([Tag].self, from: data)
            DispatchQueue.main.async(execute: {
                success?(tags)
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
