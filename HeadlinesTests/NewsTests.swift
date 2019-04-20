//
//  NewsParsingTests.swift
//  HeadlinesTests
//
//  Created by Ezequiel Becerra on 01/08/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

@testable import Canillitapp
import XCTest

// swiftlint:disable force_try
// swiftlint:disable line_length
class NewsTests: XCTestCase {

    func testNewsParsingWithWrongURL() {
        let path = Bundle
                    .init(for: NewsTests.self)
                    .path(forResource: "news_wrong_url_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // NOTE: Only one news' URL was able to be fixed
        XCTAssert(news.count == 1)
    }

    func testNewsParsingWithNullURL() {
        let path = Bundle
            .init(for: NewsTests.self)
            .path(forResource: "news_null_url_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // News should be parsed with escaped URLs
        XCTAssert(news.count == 0)
    }

    func testNewsParsingWithNullOrWrongIdentifier() {
        let path = Bundle
                    .init(for: NewsTests.self)
                    .path(forResource: "news_null_or_wrong_identifier_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // Not having identifier is considered a critical error,
        // so News should not be parsed anyways
        XCTAssert(news.count == 0)
    }

    func testNewsParsingWithNullTitle() {
        let path = Bundle
            .init(for: NewsTests.self)
            .path(forResource: "news_null_title_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // Not having title is considered a critical error,
        // so News should not be parsed anyways
        XCTAssert(news.count == 0)
    }

    func testNewsParsingWithNullOrWrongDate() {
        let path = Bundle
            .init(for: NewsTests.self)
            .path(forResource: "news_null_or_wrong_date_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // Not having date is considered a critical error,
        // so News should not be parsed anyways
        XCTAssert(news.count == 0)
    }

    func testNewsParsing() {
        let path = Bundle
            .init(for: NewsTests.self)
            .path(forResource: "news_mock", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        // Array should not be null
        XCTAssertNotNil(news)

        // All should be good
        XCTAssert(news.count == 4)

        news.forEach { n in
            XCTAssertNotNil(n.identifier)
            XCTAssertNotNil(n.title)
            XCTAssertNotNil(n.url)
            XCTAssertNotNil(n.date)
            XCTAssertNotNil(n.source)
            XCTAssertNotNil(n.imageUrl)
            XCTAssertNotNil(n.reactions)
        }

        XCTAssert(news.first!.identifier == "527386")
        XCTAssert(news.first!.url == URL(string: "http://www.lanacion.com.ar/2158062-el-turf-vuelve-a-manifestarse-contra-la-derogacion-de-la-ley-bonaerense-con-el-apoyo-de-juan-carr")!)
        XCTAssert(news.first!.title == "El turf vuelve a manifestarse contra la derogación de la ley bonaerense, con el apoyo de Juan Carr")
        XCTAssert(news.first!.date == Date(timeIntervalSince1970: 1533083699))
        XCTAssert(news.first!.category == "Actualidad")
        XCTAssert(news.first!.source == "La Nacion")
        XCTAssert(news.first!.imageUrl == URL(string: "https://bucket2.glanacion.com/anexos/fotos/93/2738693.jpg")!)

        XCTAssert(news.first!.reactions!.count == 3)
        XCTAssert(news.first!.reactions!.first!.amount == 1)
        XCTAssert(news.first!.reactions!.first!.reaction == "👍")
        XCTAssert(news.first!.reactions!.first!.date == Date(timeIntervalSince1970: 1537453332))
    }

    func testNewsFullParsing() {
        // curl https://api.canillitapp.com/latest/2018-08-31 > news_full_2018-08-31.json
        let path = Bundle
            .init(for: NewsTests.self)
            .path(forResource: "news_mock_full_2018-08-31", ofType: "json")

        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf: url)
        let news = try! News.decodeArrayOfNews(from: data)

        XCTAssert(news.count == 988)
    }
}
