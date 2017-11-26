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

class TrendingCardsViewController: UICollectionViewController {

    var topics = [Topic]()
    var footerView: UICollectionReusableView?
    let newsService = NewsService()
    var newsDataTask: URLSessionDataTask?
    var apiCallCompletionObserver: NSObjectProtocol?
    
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
    
    func fetchTrendingTopics() {
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
    
    func updateFooterView() {
        if let view = footerView {
            let shouldShowFooter = topics.count > 0 && newsDataTask?.state == .running
            view.isHidden = !shouldShowFooter
        }
    }
    
    func updateCollectionViewCellSize() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout,
            let collectionViewSize = self.collectionView?.bounds.size else {
                return
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let columns: CGFloat = floor(collectionViewSize.width / 280.0)
            let itemWidth = floor(((collectionViewSize.width - 20 - (columns-1)*10) / columns))
            flowLayout.itemSize = CGSize(width: itemWidth, height: 235)
        } else {
            flowLayout.itemSize = CGSize(width: collectionViewSize.width - 20, height: 235)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewCellSize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.minimumLineSpacing = 10
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        updateCollectionViewCellSize()
        
        let refreshCtrl = UIRefreshControl()
        collectionView?.refreshControl = refreshCtrl
        refreshCtrl.tintColor = UIColor(red: 0.99, green: 0.29, blue: 0.39, alpha: 1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchTrendingTopics), for: .valueChanged)
        
        //  Had to set content offset because of UIRefreshControl bug
        //  http://stackoverflow.com/a/31224299/994129
        collectionView?.contentOffset = CGPoint(x: 0, y: -refreshCtrl.frame.size.height)
        
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
        
        apiCallCompletionObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name(rawValue: "trendingTopicFinished"),
            object: nil,
            queue: nil,
            using: catchNotification
        )
    }
    
    func catchNotification(notification: Notification) {
        DispatchQueue.main.async {
            self.endRefreshing()
            
            guard let t = notification.userInfo?["topics"] as? [Topic] else {
                return
            }
            
            self.appendTopics(t)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Answers.logCustomEvent(withName: "trending_appear", customAttributes: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(apiCallCompletionObserver)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
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
            }
        }
    }
    
    @IBAction func unwindFromSearch(segue: UIStoryboardSegue) {
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as? KeywordCollectionViewCell else {
                
            return UICollectionViewCell()
        }
        
        let topic = topics[indexPath.row]
        
        guard let news = topic.news else {
            return cell
        }
        
        //  Tries to show a news on the topic card that contains an image,
        //  it will show a news without an image if all the news of that topic don't
        //  contain an image.
        
        let newsWithImages = news.filter({$0.imageUrl != nil})
        
        guard let firstNews = newsWithImages.first != nil ? newsWithImages.first : news.first else {
            return cell
        }
        
        if let newsDate = firstNews.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.doesRelativeDateFormatting = true
            cell.dateLabel.text = dateFormatter.string(from: newsDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            cell.timeLabel.text = timeFormatter.string(from: newsDate)
        }

        cell.titleLabel.text = topic.name
        cell.bodyLabel.text = firstNews.title
        cell.sourceLabel.text = firstNews.source
        cell.newsQuantityLabel.text = "\(news.count) noticias"
        
        cell.imageView.contentMode = .center
        
        if let imgURL = firstNews.imageUrl {
            cell.imageView.sd_setImage(
                with: imgURL,
                placeholderImage: UIImage(named: "icon_placeholder_big"),
                options: [],
                completed: { (_, error, _, _) in
                    
                    if error != nil {
                        return
                    }
                    
                    cell.imageView.contentMode = .scaleAspectFill
            })
        } else {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        performSegue(withIdentifier: "news", sender: topic)
        
        Answers.logCustomEvent(
            withName: "trending_item_tapped",
            customAttributes: [
                "topic": topic.name ?? "no_name"
            ]
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = footerView else {
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "footer",
                                                                         for: indexPath)
            updateFooterView()
            return footerView!
        }
        
        return view
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        
        if indexPath.row == topics.count-1 {
            let topic = topics[indexPath.row]
            
            guard let lastDate = topic.date else {
                return
            }
            
            let calendar = Calendar.current
            let newDate = calendar.date(byAdding: .day, value: -1, to: lastDate)
            
            requestTrendingTopicsWithDate(newDate!)
        }
    }
}
