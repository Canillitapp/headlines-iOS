//
//  TrendingTermTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

// swiftlint:disable force_try
class TrendingTermTests: XCTestCase {

    func testReactionArrayParsing() {
        let path = Bundle
            .init(for: TrendingTermTests.self)
            .path(forResource: "search_trending_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)

        let reactions = try! JSONDecoder().decode([TrendingTerm].self, from: data)

        XCTAssertNotNil(reactions)
        XCTAssert(reactions.count == 10)
    }
}
