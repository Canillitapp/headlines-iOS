//
//  MockService.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 6/4/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation

class MockService {
    
    func request(file: String,
                 success: ((_ result: Data?, _ response: URLResponse?) -> Void)?,
                 fail: ((_ error: NSError) -> Void)?) {

        let path = Bundle.main.path(forResource: file, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            success?(data, nil)
        } catch {}
    }
}
