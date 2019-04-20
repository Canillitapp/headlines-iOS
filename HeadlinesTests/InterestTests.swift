//
//  InterestTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

// swiftlint:disable force_try
class InterestTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testReactionArrayParsing() {
        let path = Bundle
            .init(for: InterestTests.self)
            .path(forResource: "interests_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        let interests = try! JSONDecoder().decode([Interest].self, from: data)

        XCTAssertNotNil(interests)
        XCTAssert(interests.count == 20)
    }
}
