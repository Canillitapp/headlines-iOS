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
                         handler: ((Result<String?, Error>) -> Void)?) {

        let container = CKContainer.default()
        container.fetchUserRecordID { [weak self] (recordId, error) in
            if let err = error {
                handler?(.failure(err))
                return
            }

            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "ContentViewsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                handler?(.failure(err))
                return
            }

            let params = [
                "news_id": newsIdentifier,
                "user_id": userId.recordName,
                "user_source": "iOS",
                "context_from": context.rawValue
                ]

            let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
                switch result {
                case .success:
                    DispatchQueue.main.async(execute: {
                        handler?(.success(nil))
                    })

                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        handler?(.failure(error))
                    })
                }
            }

            _ = self?.request(method: .POST, path: "content-views/", params: params, handler: httpHandler)
        }
    }
}
