//
//  LoadingTask.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 02/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class LoadingTask {

    /**
     *  First approach was doing an OperationQueue with OperationBlocks
     *  but since I'm not going to handle their cancel / fail state I thought
     *  this was more clear.
     *
     *  I could also make FetchCategoriesOperation and FetchTrendingNewsOperation
     *  as Operation subclasses but it seemed too much work for something that it's
     *  not going to have reuse on other part of the app's lifecycle.
     *
     *  However, there's a something to have in mind: both operations are going to
     *  run no matter what. If some of the two fails and later user retries, both
     *  API calls are going to run.
     *
     *  Also, if both services fail, I'm gonna get just one error (the last one).
     *
     *  There's some room to improvement here :-)
     */

    let group = DispatchGroup()
    var error: NSError?

    var topics: [Topic]?
    var categories: [Category]?

    var completion: ([Topic]?, [Category]?, NSError?) -> Void

    private func fetchTrendingNews() {
        let newsService = NewsService()

        let success: (TopicList?) -> Void = { [unowned self] topicList in
            self.topics = topicList?.topics
            self.group.leave()
        }

        let fail: ((NSError) -> Void) = { [unowned self] error in
            self.error = error
            self.group.leave()
        }

        _ = newsService.requestTrendingTopicsWithDate(
            Date(),
            count: 6,
            success: success,
            fail: fail
        )
        group.enter()
    }

    private func fetchCategories() {
        let categoriesService = CategoriesService()

        let success: ([Category]?) -> Void = { [unowned self] categories in
            self.categories = categories
            self.group.leave()
        }

        let fail: ((NSError) -> Void) = { [unowned self] error in
            self.error = error
            self.group.leave()
        }

        categoriesService.categoriesList(success: success, fail: fail)
        group.enter()
    }

    init(with completion:@escaping ([Topic]?, [Category]?, NSError?) -> Void) {
        self.completion = completion
    }

    func start() {
        fetchTrendingNews()
        fetchCategories()

        group.notify(queue: DispatchQueue.main) { [unowned self] in
            self.completion(self.topics, self.categories, self.error)
        }
    }
}
