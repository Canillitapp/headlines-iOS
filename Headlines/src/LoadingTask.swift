//
//  LoadingTask.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 02/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation

class LoadingTask {
    
    let queue = OperationQueue()
    
    var newsFetched: [Topic]?
    let newsService = NewsService()
    
    var categoriesFetched: [Category]?
    let categoriesService = CategoriesService()
    
    var completion: () -> Void
    
    func fetchNewsOperation() -> BlockOperation {
        return BlockOperation { [unowned self] in
            let group = DispatchGroup()
            group.enter()
            
            let success: ([Topic]?) -> Void = { [unowned self] (topics) in
                self.newsFetched = topics
                print("Hello world 1")
                group.leave()
            }
            
            _ = self.newsService.requestTrendingTopicsWithDate(
                Date(),
                count: 6,
                success: success,
                fail: nil
            )
            group.wait()
        }
    }
    
    func fetchCategoriesOperation() -> BlockOperation {
        return BlockOperation { [unowned self] in
            let group = DispatchGroup()
            group.enter()
            
            let success: ([Category]?) -> Void = { [unowned self] (categories) in
                self.categoriesFetched = categories
                print("Hello world 2")
                group.leave()
            }
            
            self.categoriesService.categoriesList(success: success, fail: nil)
            group.wait()
        }
    }
    
    init(with completion: @escaping () -> Void) {
        queue.name = "Loading Queue"
        queue.maxConcurrentOperationCount = 2
        self.completion = completion
    }
    
    func start() {
        let newsOperation = fetchNewsOperation()
        let categoriesOperation = fetchCategoriesOperation()
        
        let mergeOperation = BlockOperation { [unowned self] in
            self.completion()
        }
        mergeOperation.addDependency(newsOperation)
        mergeOperation.addDependency(categoriesOperation)
        
        let operations = [newsOperation, categoriesOperation, mergeOperation]
        queue.addOperations(operations, waitUntilFinished: false)
    }
}
