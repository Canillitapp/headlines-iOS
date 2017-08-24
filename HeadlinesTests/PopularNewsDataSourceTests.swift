//
//  PopularNewsDataSourceTests.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

class PopularNewsDataSourceTests: XCTestCase {
    
    let dataSource = PopularNewsDataSource()
    
    func testFetchNews() {
        let exp = expectation(description: "Get fake response from JSON file")
        
        self.dataSource.fetchNews(success: { (_) in
            exp.fulfill()
        }) { (error) in
            XCTFail(error.localizedDescription)
        }
        wait(for: [exp], timeout: 10)
    }
    
}
