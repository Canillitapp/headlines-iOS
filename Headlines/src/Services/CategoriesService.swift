//
//  CategoriesService.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 30/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class CategoriesService: HTTPService {

    func categoriesList (handler: ((_ result: Result <[Category]?, Error>) -> Void)?) {

//        if ProcessInfo.processInfo.arguments.contains("mockRequests") {
//            let mockService = MockService()
//            _ = mockService.request(file: "GET-categories",
//                                    success: successBlock,
//                                    fail: failBlock)
//            return
//        }

        let httpHandler: ((Result <Data?, Error>) -> Void) = { result in
            switch result {
            case .success(let data):
                guard let d = data else {
                    handler?(.success(nil))
                    return
                }

                let res = try? JSONDecoder().decode([Category].self, from: d)

                DispatchQueue.main.async(execute: {
                    handler?(.success(res))
                })

            case .failure(let error):
                handler?(.failure(error))
                return
            }
        }

        _ = request(method: .GET, path: "categories/", params: nil, handler: httpHandler)
    }
}
