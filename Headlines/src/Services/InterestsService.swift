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
    func getInterests(success: ((_ response: URLResponse?, [Interest]) -> Void)?,
                      fail: ((_ error: Error) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let d = data else {
                return
            }

            let interests = (try? JSONDecoder().decode([Interest].self, from: d)) ?? [Interest]()
            
            DispatchQueue.main.async(execute: {
                success?(response, interests)
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-interests",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                DispatchQueue.main.async(execute: {
                    fail?(err)
                })
                return
            }
            
            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: "InterestsService",
                                  code: 1,
                                  userInfo: errUserInfo)
                
                DispatchQueue.main.async(execute: {
                    fail?(err)
                })
                return
            }
            
            _ = self.request(method: .GET,
                             path: "interests/\(userId.recordName)/iOS",
                params: nil,
                success: successBlock,
                fail: failBlock)
        }
    }
}
