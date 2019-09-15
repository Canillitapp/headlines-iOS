//
//  BaseService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 5/3/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

enum Method {
    case DELETE, GET, POST, PUT
}

typealias HTTPResult = Result<(response: URLResponse?, data: Data?), Error>

class HTTPService {

    func baseURL() -> String {
        guard let baseURL = ConfigHelper.configForKey("base_url") as? String else {
            return "http://api.canillitapp.com"
        }

        return baseURL
    }

    func request(method: Method,
                 path: String,
                 params: [String: String]?,
                 headers: [String: String]? = nil,
                 handler: ((_ result: HTTPResult) -> Void)?) -> URLSessionDataTask? {

        let url = URL(string: "\(baseURL())/\(path)")
        var request = URLRequest(url: url!)

        switch method {
        case .POST:
            request.httpMethod = "POST"
        default:
            break
        }

        if let headers = headers {
            headers.forEach { (k, v) in
                request.addValue(v, forHTTPHeaderField: k)
            }
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        if let p = params {
            var tmp = [String]()
            for (k, v) in p {
                tmp.append("\(k)=\(v)")
            }
            let httpBody = tmp.joined(separator: "&")
            request.httpBody = httpBody.data(using: .utf8)
        }

        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            if let e = error {
                handler?(.failure(e))
                return
            }

            handler?(.success((response: response, data: data)))
        })

        task.resume()
        return task
    }
}
