//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/28/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import CloudKit

// swiftlint:disable force_try
class NewsService: HTTPService {

    func requestFromCategory (_ categoryId: String,
                              page: Int = 1,
                              handler: ((_ result: Result <[News], Error>) -> Void)?) {

        let path = "news/category/\(categoryId)?page=\(page)"

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([News]()))
                    return
                }

                let res = (try? News.decodeArrayOfNews(from: d)) ?? [News]()

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })

            case .failure(let error):
                handler?(.failure(error))
                return
            }
        }

        _ = request(method: .GET, path: path, params: nil, handler: httpHandler)
    }

    func requestPopularNews (page: Int = 1,
                             handler: ((_ result: Result <[News], Error>) -> Void)?) {

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([]))
                    return
                }

                let res = (try? News.decodeArrayOfNews(from: d)) ?? []

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })
            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-popular", handler: httpHandler)
            return
        }

        let path = "popular?page=\(page)"
        _ = request(method: .GET, path: path, params: nil, handler: httpHandler)
    }

    func requestRecentNewsWithDate (_ date: Date,
                                    handler: ((_ result: Result <[News], Error>) -> Void)?) {

        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)

        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([News]()))
                    return
                }

                let res = (try? News.decodeArrayOfNews(from: d)) ?? [News]()

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })
            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-recent", handler: httpHandler)
            return
        }

        _ = request(method: .GET, path: "latest/\(datePath)", params: nil, handler: httpHandler)
    }

    func requestTrendingTopicsWithDate (_ date: Date,
                                        count: Int,
                                        handler: ((_ result: Result <TopicList?, Error>) -> Void)?) -> URLSessionDataTask? {

        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)

        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success(nil))
                    return
                }

                let res = try? JSONDecoder().decode(TopicList.self, from: d)

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })

            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-trending", handler: httpHandler)
            return nil
        }

        let task = request(
            method: .GET,
            path: "trending/\(datePath)/\(count)",
            params: nil,
            handler: httpHandler
        )

        return task
    }

    func searchNews(_ text: String,
                    handler: ((_ result: Result <[News], Error>) -> Void)?) -> URLSessionDataTask? {

        let group = DispatchGroup()

        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([]))
                    return
                }

                let res = (try? News.decodeArrayOfNews(from: d)) ?? []

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })
            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search", handler: httpHandler)
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

        let task = self.request(method: .GET, path: "search/\(encodedText)", params: nil, handler: httpHandler)
        return task
    }

    func fetchTrendingTerms(handler: ((_ handler: Result <[TrendingTerm], Error>) -> Void)?) {

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([]))
                    return
                }

                let res = (try? JSONDecoder().decode([TrendingTerm].self, from: d)) ?? [TrendingTerm]()

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })
            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search-trending", handler: httpHandler)
            return
        }

        _ = request(method: .GET, path: "search/trending/", params: nil, handler: httpHandler)
    }

    @discardableResult
    func fetchTags(tag: String,
                   handler: ((_ handler: Result <[Tag], Error>) -> Void)?) -> URLSessionDataTask? {

        let httpHandler: ((HTTPResult) -> Void) = { result in
            switch result {
            case .success(let success):
                guard let d = success.data else {
                    handler?(.success([Tag]()))
                    return
                }

                let res = (try? JSONDecoder().decode([Tag].self, from: d)) ?? [Tag]()

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })
            case .failure(let error):
                handler?(.failure(error))
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-search-term", handler: httpHandler)
            return nil
        }

        let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? String()
        let task = request(method: .GET, path: "tags/\(encodedTag)", params: nil, handler: httpHandler)
        return task
    }
}
