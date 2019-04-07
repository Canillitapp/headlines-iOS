//
//  TopicListTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 07/04/2019.
//  Copyright © 2019 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

// swiftlint:disable force_try
class TopicListTests: XCTestCase {

    func testTopicTestParsing() {
        let path = Bundle(for: TopicListTests.self).path(forResource: "trending_20190407_12_mock", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let topicList = try! JSONDecoder().decode(TopicList.self, from: data)

        XCTAssert(topicList.keywords.count == 12)

        let riachueloTopic = topicList.topics.filter { $0.name?.lowercased() == "riachuelo" }.first
        XCTAssertNotNil(riachueloTopic)
        XCTAssert(riachueloTopic?.name! == "Riachuelo")

        // NOTE: They're actually 14 news but one is invalid due to an invalid URL
        XCTAssert(riachueloTopic?.news?.count == 13)
    }
}
