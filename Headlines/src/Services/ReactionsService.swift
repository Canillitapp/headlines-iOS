//
//  ReactionsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ReactionsService: NSObject {

    func postReaction(_ reaction: String,
                      atNews news: News,
                      success: ((_ response: URLResponse?) -> ())?,
                      fail: ((_ error: Error) -> ())?) {
        
        guard let newsId = news.identifier else {
            return
        }
        
        let url = URL(string: "http://45.55.247.52:4567/reactions/\(newsId)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let postString = "reaction=\(reaction)"
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
