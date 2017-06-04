//
//  ServiceProtocol.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 6/4/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

enum Method {
    case DELETE, GET, POST, PUT
}

protocol ServiceProtocol {
    func request(method: Method,
                 path: String,
                 params: [String:String]?,
                 success: ((_ result: Data?, _ response: URLResponse?) -> Void)?,
                 fail: ((_ error: NSError) -> Void)?) -> URLSessionDataTask?
}
