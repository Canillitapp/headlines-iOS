//
//  MockService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 6/4/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

class MockService {

    func request(file: String, handler: ((_ result: HTTPResult) -> Void)?) {
        let path = Bundle.main.path(forResource: file, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: url)
        DispatchQueue.main.async {
            handler?(.success((nil, data)))
        }
    }
}
