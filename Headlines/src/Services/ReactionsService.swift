//
//  ReactionsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit

// swiftlint:disable force_try
class ReactionsService: HTTPService {

    func postReaction(_ reaction: String,
                      atPost postId: String,
                      handler: ((_ response: Result <News?, Error>) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                DispatchQueue.main.async(execute: {
                    handler?(.failure(err))
                })
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ReactionsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                DispatchQueue.main.async(execute: {
                    handler?(.failure(err))
                })
                return
            }

            let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
                switch result {
                case .success(let data):
                    guard let d = data else {
                        return
                    }

                    let res = try! JSONDecoder().decode(News.self, from: d)

                    DispatchQueue.main.async(execute: {
                        handler?(.success(res))
                    })

                case .failure(let error):
                    handler?(.failure(error))
                }
            }

            let params = [
                "reaction": reaction,
                "source": "iOS",
                "user_id": userId.recordName
            ]

            _ = self.request(method: .POST, path: "reactions/\(postId)", params: params, handler: httpHandler)
        }
    }

    func getReactions(handler: ((_ result: Result <[Reaction], Error>) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                DispatchQueue.main.async(execute: {
                    handler?(.failure(err))
                })
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ReactionsService",
                                  code: 1,
                                  userInfo: errUserInfo)

                DispatchQueue.main.async(execute: {
                    handler?(.failure(err))
                })
                return
            }

            let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
                switch result {
                case .success(let data):
                    guard let d = data else {
                        handler?(.success([]))
                        return
                    }

                    let res = (try? JSONDecoder().decode([Reaction].self, from: d)) ?? []

                    DispatchQueue.main.async(execute: {
                        handler?(.success(res))
                    })

                case .failure(let error):
                    handler?(.failure(error))
                }
            }

            if ProcessInfo.processInfo.arguments.contains("mockRequests") {
                let mockService = MockService()
                _ = mockService.request(file: "GET-reactions", handler: httpHandler)
                return
            }

            _ = self.request(
                method: .GET,
                path: "reactions/\(userId.recordName)/iOS",
                params: nil,
                handler: httpHandler
            )
        }
    }
}
