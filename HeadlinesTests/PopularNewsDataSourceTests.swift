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

        let handler: ((Result<[News], Error>) -> Void) = { result in
            switch result {
            case .success(_):
                exp.fulfill()

            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }

        self.dataSource.fetchNews(page: 1, handler: handler)
        wait(for: [exp], timeout: 10)
    }

}
