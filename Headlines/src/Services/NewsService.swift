//
//  NewsService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsService {
    func trendingNews (completion: (result: AnyObject?) -> Void) {
        Alamofire.request(.GET, "http://10.0.1.28:4567/trending/2016-08-16")
            .responseJSON { response in

                guard response.result.isSuccess else {
                    completion(result: nil)
                    return
                }

                completion(result: response.result.value)
        }
    }
}
