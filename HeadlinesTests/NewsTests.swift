//
//  NewsParsingTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 01/08/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

class NewsTests: XCTestCase {
    
    func testNewsParsingWithNullOrWrongURL() {
        let path = Bundle.init(for: NewsTests.self).path(forResource: "news_null_or_wrong_url_mock", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let decoder = JSONDecoder()
        let data = try? Data(contentsOf: url)
        let news = try? decoder.decode([Safe<News>].self, from: data!)
        
        // Array should not be null
        XCTAssertNotNil(news)
        
        news!.forEach { (n) in
            // News should be parsed anyways
            XCTAssertNotNil(n.value)
            
            // News should have url == nil
            XCTAssertNil(n.value!.url)
        }
    }
}
