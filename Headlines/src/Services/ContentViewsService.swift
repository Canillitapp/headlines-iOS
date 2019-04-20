//
//  ContentViewsService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 15/05/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit

enum ContentViewContextFrom: String {
    case search, trending, popular, recent, reactions, category
}

class ContentViewsService: HTTPService {

    func postContentView(_ newsIdentifier: String,
                         context: ContentViewContextFrom,
                         success: ((_ response: URLResponse?) -> Void)?,
                         fail: ((_ error: Error) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                fail?(err)
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ContentViewsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                fail?(err)
                return
            }

            let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
                DispatchQueue.main.async(execute: {
                    success?(response)
                })
            }

            let failBlock: (_ error: NSError) -> Void = { (e) in
                DispatchQueue.main.async(execute: {
                    fail?(e as NSError)
                })
            }

            let params = [
                "news_id": newsIdentifier,
                "user_id": userId.recordName,
                "user_source": "iOS",
                "context_from": context.rawValue
                ]

            _ = self.request(method: .POST,
                             path: "content-views/",
                             params: params,
                             success: successBlock,
                             fail: failBlock)
        }
    }
}
