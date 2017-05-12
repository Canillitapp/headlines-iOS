//
//  ReactionsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import CloudKit
import SwiftyJSON

class ReactionsService: BaseService {

    func postReaction(_ reaction: String,
                      atNews news: News,
                      success: ((_ response: URLResponse?, News?) -> Void)?,
                      fail: ((_ error: Error) -> Void)?) {
        
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
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: NSStringFromClass(self.classForCoder),
                                  code: 1,
                                  userInfo: errUserInfo)
                fail?(err)
                return
            }
            
            let url = URL(string: "\(self.baseURL())/reactions/\(newsId)")
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
                
                guard let d = data else {
                    return
                }
                
                let json = JSON(data: d)
                
                let n = News(json: json)
                
                DispatchQueue.main.async(execute: {
                    success?(response, n)
                })
            })
            
            task.resume()
        }
    }
    
    func getReactions(success: ((_ response: URLResponse?, [Reaction]) -> Void)?,
                      fail: ((_ error: Error) -> Void)?) {
        
        let container = CKContainer.default()
        container.fetchUserRecordID { (recordId, error) in
            if let err = error {
                fail?(err)
                return
            }
            
            guard let userId = recordId else {
                let errUserInfo = [NSLocalizedDescriptionKey: "No user record id"]
                let err = NSError(domain: NSStringFromClass(self.classForCoder),
                                  code: 1,
                                  userInfo: errUserInfo)
                fail?(err)
                return
            }
            
            let url = URL(string: "\(self.baseURL())/reactions/\(userId.recordName)/iOS")
            let request = URLRequest(url: url!)
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                if let e = error {
                    fail?(e as NSError)
                    return
                }
                
                guard let d = data else {
                    return
                }
                
                let json = JSON(data: d)
                
                var reactions = [Reaction]()
                json.forEach ({ (_, j) in
                    let r = Reaction(json: j)
                    reactions.append(r)
                })
                
                DispatchQueue.main.async(execute: {
                    success?(response, reactions)
                })
            })
            
            task.resume()
        }
    }
}
