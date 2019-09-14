//
//  InterestsService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 28/10/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit

class InterestsService: HTTPService {

    func getInterests(handler: ((_ result: Result <[Interest], Error>) -> Void)?) {

        let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                guard let d = data else {
                    handler?(.success([Interest]()))
                    return
                }

                let res = (try? JSONDecoder().decode([Interest].self, from: d)) ?? [Interest]()

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })

            case .failure(let error):
                handler?(.failure(error))
                return
            }
        }

        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-interests", handler: httpHandler)
            return
        }

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
                let err = NSError(domain: "InterestsService",
                                  code: 1,
                                  userInfo: errUserInfo)

                DispatchQueue.main.async(execute: {
                    handler?(.failure(err))
                })
                return
            }

            _ = self.request(
                method: .GET,
                path: "interests/\(userId.recordName)/iOS",
                params: nil,
                handler: httpHandler
            )
        }
    }
}
