//
//  CategoriesService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 30/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class CategoriesService: HTTPService {
    
    private let decoder = JSONDecoder()
    
    func categoriesList (success: ((_ result: [Category]?) -> Void)?,
                         fail: ((_ error: NSError) -> Void)?) {
        
        let successBlock: (_ result: Data?, _ response: URLResponse?) -> Void = {(data, response) in
            guard let data = data else {
                return
            }
            let categories = try? self.self.decoder.decode([Category].self, from: data)
            DispatchQueue.main.async(execute: {
                success?(categories)
            })
        }
        
        let failBlock: (_ error: NSError) -> Void = { (e) in
            DispatchQueue.main.async(execute: {
                fail?(e as NSError)
            })
        }
        
        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
            let mockService = MockService()
            _ = mockService.request(file: "GET-categories",
                                    success: successBlock,
                                    fail: failBlock)
            return
        }
        
        _ = request(method: .GET, path: "categories/", params: nil, success: successBlock, fail: failBlock)
    }
}
