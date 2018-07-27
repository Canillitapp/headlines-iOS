//
//  TopicTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 02/12/2017.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

class TopicTests: XCTestCase {
    
    func testRepresentativeReaction() throws {
        let path = Bundle.main.path(forResource: "topic_mock", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        let topicResponse = try decoder.decode(TopicResponse.self, from: data)
        let topics = topicResponse.topics(date: Date())
        
        guard let t = topics.first else {
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
