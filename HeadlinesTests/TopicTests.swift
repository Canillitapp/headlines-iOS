//
//  TopicTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 02/12/2017.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

// swiftlint:disable force_try
class TopicTests: XCTestCase {

    var topics: [Topic]?

    override func setUp() {
        super.setUp()

        let path = Bundle.main.path(forResource: "topic_mock", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        do {
            let data = try Data(contentsOf: url)
            let topicList = try! JSONDecoder().decode(TopicList.self, from: data)
            topics = topicList.topics
        } catch {}
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRepresentativeReaction() {
        guard let t = topics?.first else {
            XCTAssert(false)
            return
        }

        XCTAssertNotNil(t.representativeReaction)

        let topicRepresentativeReaction = t.representativeReaction?.reaction
        XCTAssert(topicRepresentativeReaction == "🙂")

        let newsRepresentativeReaction = t.news?.first?.representativeReaction?.reaction
        XCTAssert(newsRepresentativeReaction == "😱")
    }
}
