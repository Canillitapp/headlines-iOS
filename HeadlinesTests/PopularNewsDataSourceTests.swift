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
        
        let success: ([News]) -> Void = { (news) in
            exp.fulfill()
        }
        
        let fail: (NSError) -> Void = { (error) in
            XCTFail(error.localizedDescription)
        }
        
        self.dataSource.fetchNews(success: success, fail: fail)
        
        wait(for: [exp], timeout: 10)
    }
    
}
