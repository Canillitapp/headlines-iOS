//
//  ReactionTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 06/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

// swiftlint:disable force_try
class ReactionTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testReactionArrayParsing() {
        let path = Bundle
            .init(for: ReactionTests.self)
            .path(forResource: "reactions_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try? Data(contentsOf: url)

        let reactions = try! JSONDecoder().decode([Reaction].self, from: data!)

        XCTAssertNotNil(reactions)
        XCTAssert(reactions.count == 3)
    }
}
