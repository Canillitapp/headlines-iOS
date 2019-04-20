//
//  FilterSourcesDataSourceTests.swift
//  HeadlinesTests
//
//  Created by Marcos Griselli on 13/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import XCTest
@testable import Canillitapp

class FilterSourcesDataSourceTests: XCTestCase {

    func testSources() {
        let news = ["Clarín", "La Nación", nil, "Infobae"].map(newsCellViewModelWith)
        let sources = FilterSourcesDataSource.sources(fromNews: news)
        XCTAssertEqual(sources, ["Clarín", "Infobae", "La Nación"])
    }

    func testPreSelectedSources() {
        let viewModels = ["Clarín", "La Nación", "Infobae"]
            .map(newsCellViewModelWith)
        let sources = FilterSourcesDataSource.preSelectedSources(
            fromNewsViewModels: viewModels
        )
        let expected = ["La Nación", "Infobae", "Clarín"] // no sorting
        sources.forEach { XCTAssertTrue(expected.contains($0)) }
    }

    private func newsWith(source: String?) -> News {
        let url = URL(string: "http://www.betzerra.github.io")
        let news = News(identifier: "1", url: url!, title: "Foo", date: Date())
        news.source = source
        return news
    }

    private func newsCellViewModelWith(source: String?) -> NewsCellViewModel {
        let news = newsWith(source: source)
        return NewsCellViewModel(news: news)
    }
}
