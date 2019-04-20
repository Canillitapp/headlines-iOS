//
//  RecentNewsDataSourceTests.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/22/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

class RecentNewsDataSourceTests: XCTestCase {

    let dataSource = RecentNewsDataSource()

    func testFetchNews() {
        let exp = expectation(description: "Get fake response from JSON file")

        let success: ([News]) -> Void = { _ in
            exp.fulfill()
        }

        let fail: (NSError) -> Void = { error in
            XCTFail(error.localizedDescription)
        }

        self.dataSource.fetchNews(page: 1, success: success, fail: fail)
        wait(for: [exp], timeout: 10)
    }
}
