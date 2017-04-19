//
//  ReactionsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit

class ReactionsService: NSObject {

    func postReaction(_ reaction: String,
                      atNews news: News,
                      success: ((_ response: URLResponse?) -> ())?,
                      fail: ((_ error: Error) -> ())?) {
        
        guard let newsId = news.identifier else {
            return
        }
        
        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                fail?(err)
                return
            }
            
            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey : "No user record id"]
                let err = NSError(domain: NSStringFromClass(self.classForCoder),
                                  code: 1,
                                  userInfo: errUserInfo)
                fail?(err)
                return
            }
            
            let url = URL(string: "http://127.0.0.1:4567/reactions/\(newsId)")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let postString = "reaction=\(reaction)&source=iOS&user_id=\(userId.recordName)"
            request.httpBody = postString.data(using: .utf8)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                if let e = error {
                    fail?(e as NSError)
                    return
                }
                
                DispatchQueue.main.async(execute: {
                    success?(response)
                })
            })
            
            task.resume()
        }
    }
}
