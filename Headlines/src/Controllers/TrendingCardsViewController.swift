//
//  MasterViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 8/23/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SDWebImage
import Crashlytics

class TrendingCardsViewController: UIViewController {

    var topics = [Topic]()
    var footerView: UICollectionReusableView?
    let newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    var userSettingsManager = UserSettingsManager()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoriesContainerViewModel: CategoriesContainerViewModel?
    
    var reviewViewModel = ReviewBannerViewModel()
    var reviewView: ReviewView?
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    func endRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    func startRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            self.collectionView?.refreshControl?.beginRefreshing()
        }
    }
    
    @objc func fetchTrendingTopics() {
        self.startRefreshing()
        
        topics.removeAll()
        collectionView?.reloadData()
        
        requestTrendingTopicsWithDate(Date())
    }
    
    func stringFromData(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day, .month, .year], from: date)
        
        let datePath = String(format: "%d-%02d-%02d", components.year!, components.month!, components.day!)
        return datePath
    }
    
    func appendTopics(_ items: [Topic]) {
        /**
         *  Added some logic to avoid appending items for a date
         *  that was already posted.
         *
         *  First we filter topics with all items with valid date
         *  (this should be everyone) but just to make sure of that
         *  to avoid a crash.
         *
         *  Then we obtain every posted date and save it on itemsDates.
         */
        
        let itemsDates = Set(topics
                                .filter { $0.date != nil }
                                .map { self.stringFromData($0.date!) }
        )
        
        // After that, we make sure that every new item is from a new date.
        let filteredItems = items.filter { (t) -> Bool in
            return !itemsDates.contains(self.stringFromData(t.date!))
        }
        
        // If there's no new posts, just skip everything and update the footer view
        if filteredItems.count > 0 {
            var indexPaths = [IndexPath]()
            let startIndex = self.topics.count
            let endIndex = startIndex + filteredItems.count-1
            
            for index in startIndex...endIndex {
                let i = IndexPath(row: index, section: 0)
                indexPaths.append(i)
            }
            
            self.topics.append(contentsOf: filteredItems)
            self.collectionView?.insertItems(at: indexPaths)
        }
        
        self.updateFooterView()
    }
    
    func requestTrendingTopicsWithDate(_ date: Date) {
        newsDataTask = newsService.requestTrendingTopicsWithDate(date, count: 6, success: { (result) in
            
            self.endRefreshing()
            
            guard let r = result else {
                return
            }
            
            /*  
             *  Horrible recursive hot-fix to avoid not showing anything because
             *  that current date has no results
             */
            
            if r.count == 0 {
                let calendar = Calendar.current
                if let newDate = calendar.date(byAdding: .day, value: -1, to: date) {
                    self.requestTrendingTopicsWithDate(newDate)
                }
                return
            }
            
            self.appendTopics(r)
            
        }, fail: { (error) in
            print(error.localizedDescription)
            self.updateFooterView()
            
            Answers.logCustomEvent(
                withName: "request_failed",
                customAttributes: [
                    "service": "GET-trending",
                    "error-debug": error.debugDescription,
                    "error-localized": error.localizedDescription
                ]
            )
        })
        
        updateFooterView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.updateCollectionViewCellSize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReviewView()
        
        if let categories = NewsManager.sharedInstance.categories {
            CategoriesContainerViewModel.preloadCategoriesImages(from: categories)
            categoriesContainerViewModel = CategoriesContainerViewModel(delegate: self,
                                                                        collectionView: collectionView,
                                                                        categories: categories)
        }
        
        setupCollectionView()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.newsDataTask = appDelegate.newsDataTask
            
            if let n = appDelegate.newsFetched {
                self.topics.append(contentsOf: n)
            }
        }
        
        if topics.count == 0 {
            startRefreshing()
            
            if self.newsDataTask?.state != .running {
                fetchTrendingTopics()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Answers.logCustomEvent(withName: "trending_appear", customAttributes: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        if identifier == "news" {
            if let vc = segue.destination as? NewsTableViewController,
                let topic = sender as? Topic,
                let topicName = topic.name,
                let topicNews = topic.news {
                
                vc.title = topicName
                vc.news = topicNews
                vc.trackContextFrom = .trending
                
                // Save "Siri suggestion" to search news for <Topic>
                if #available(iOS 12.0, *) {
                    let activity = SuggestionsHelper.searchActivity(from: topicName)
                    vc.userActivity = activity
                }
            }
        } else if identifier == "category" {
            if let vc = segue.destination as? NewsTableViewController,
                let category = sender as? Category {
                
                vc.title = category.name
                vc.analyticsIdentifier = "category"
                vc.trackContextFrom = .category
                vc.preferredDateStyle = .short
                vc.newsDataSource = CategoryNewsDataSource(category: category)
            }
        }
    }
    
    @IBAction func unwindFromSearch(segue: UIStoryboardSegue) {
    }
    
}

// MARK: - TabbedViewController
extension TrendingCardsViewController: TabbedViewController {
    
    func tabbedViewControllerWasDoubleTapped() {
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}

// MARK: - CategoriesContainerViewModelDelegate
extension TrendingCardsViewController: CategoriesContainerViewModelDelegate {
    
    func didSelectCategory(_ category: Category) {
        performSegue(withIdentifier: "category", sender: category)
    }
}
