//
//  BaseService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 5/3/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

class BaseService: NSObject {
    
    func baseURL() -> String {
        guard let baseURL = ConfigHelper.configForKey("base_url") as? String else {
            return "http://api.canillitapp.com"
        }
        
        return baseURL
    }
}
