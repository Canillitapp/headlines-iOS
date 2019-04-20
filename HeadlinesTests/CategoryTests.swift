//
//  CategoryTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

// swiftlint:disable force_try
class CategoryTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testCategoryParse() {
        let path = Bundle
            .init(for: CategoryTests.self)
            .path(forResource: "categories_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        let categories = try! JSONDecoder().decode([Canillitapp.Category].self, from: data)

        XCTAssertNotNil(categories)
        XCTAssert(categories.count == 4)
    }
}
