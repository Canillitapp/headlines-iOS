//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices
import Crashlytics
import ViewAnimator

class NewsTableViewController: UITableViewController,
                                NewsCellViewModelDelegate,
                                UIViewControllerTransitioningDelegate,
                                SFSafariViewControllerDelegate,
                                UIViewControllerPreviewingDelegate,
                                TabbedViewController {
    
    var news: [News] = [] {
        didSet {
            newsViewModels.removeAll()
            filteredNewsViewModels.removeAll()
            news.forEach({ (n) in
                let viewModel = NewsCellViewModel(news: n)
                viewModel.delegate = self
                viewModel.dateStyle = preferredDateStyle
                newsViewModels.append(viewModel)
                filteredNewsViewModels.append(viewModel)
            })
        }
    }
    
    var selectedNews: News?
    
    var preferredDateStyle: DateFormatter.Style = .none
    var trackContextFrom: ContentViewContextFrom?
    
    let reactionsService = ReactionsService()
    let contentViewsService = ContentViewsService()
    
    var newsViewModels: [NewsCellViewModel] = []
    var filteredNewsViewModels: [NewsCellViewModel] = []
    var newsDataSource: NewsTableViewControllerDataSource?
    var analyticsIdentifier: String?
    let userSettingsManager = UserSettingsManager()
    
    // MARK: Private
    private func trackOpenNews(_ news: News) {
        guard let identifier = news.identifier,
                let contextFrom = trackContextFrom else {
            return
        }
        
        contentViewsService.postContentView(identifier, context: contextFrom, success: nil, fail: nil)
    }
    
    func openNews(_ news: News) {
        
        trackOpenNews(news)
        
        guard let url = news.url else {
            return
        }
        
        if userSettingsManager.shouldOpenNewsInsideApp {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            self.selectedNews = news
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func endRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func startRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            refreshControl?.beginRefreshing()
        }
    }
    
    func showControllerWithError(_ error: NSError) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Sorry",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func addReaction(_ currentReaction: String, toNews currentNews: News) {
        guard let n = filteredNewsViewModels.filter ({$0.news.identifier == currentNews.identifier}).first else {
            return
        }
        
        n.news.reactions = currentNews.reactions?.sorted(by: { $0.date < $1.date })
        
        if let i = filteredNewsViewModels.index(of: n) {
            let indexPathToReload = IndexPath(row: i, section: 0)
            tableView.reloadRows(at: [indexPathToReload], with: .none)
        }
        
        Answers.logCustomEvent(
            withName: "posted_reaction",
            customAttributes: [
                "reaction": currentReaction
            ]
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "reaction":
            guard let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? ReactionPickerViewController,
                let newsViewModel = sender as? NewsCellViewModel else {
                    return
            }
            
            vc.news = newsViewModel.news
            nav.modalPresentationStyle = .formSheet
        
        case "filter":
            guard let vc = segue.destination as? FilterViewController else {
                return
            }

            let sources = FilterSourcesDataSource.sources(fromNews: news)
            let selectedSources = FilterSourcesDataSource.preSelectedSources(fromNewsViewModels: filteredNewsViewModels)
            vc.filterSourcesDataSource = FilterSourcesDataSource(sources: sources, preSelectedSources: selectedSources)
            
            let categories = FilterCategoriesDataSource.categories(fromNews: news)
            let categoriesDataSource = FilterCategoriesDataSource(withCategories: categories)
            categoriesDataSource.viewController = vc
            vc.filterCategoriesDataSource = categoriesDataSource
            
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .overFullScreen
            
        default:
            return
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: tableView)
        
        guard let indexPath = tableView.indexPathForRow(at: p) else {
            return
        }
        
        let viewModel = filteredNewsViewModels[indexPath.row]
        
        let vc = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        vc.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        
        let shareAction = UIAlertAction(title: "Compartir Noticia", style: .default) { (_) in
            UIPasteboard.general.string = ShareCanillitapActivity.canillitappURL(fromNews: viewModel.news)
            vc.dismiss(animated: true, completion: nil)
        }
        vc.addAction(shareAction)
        
        let reactAction = UIAlertAction(title: "Agregar Reacción", style: .default) { [weak self] (_) in
            vc.dismiss(animated: false, completion: nil)
            self?.performSegue(withIdentifier: "reaction", sender: viewModel)
        }
        vc.addAction(reactAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in
            vc.dismiss(animated: true, completion: nil)
        }
        vc.addAction(cancelAction)
        
        present(vc, animated: true, completion: nil)
    }
    
    func fetchNews() {
        guard let ds = self.newsDataSource else {
            return
        }
        
        self.startRefreshing()
        
        let success: ([News]) -> Void = { [unowned self] (result) in
            self.endRefreshing()
            
            self.news.removeAll()
            self.news.append(contentsOf: result)
            
            if ds.isFilterEnabled {
                if let whitelist = self.userSettingsManager.whitelistedSources {
                    if whitelist.count > 0 {
                        self.filteredNewsViewModels = self.newsViewModels.filter { whitelist.contains($0.source!) }
                    }
                }
            }
            
            self.tableView?.prepareViews()
            
            self.tableView.reloadData()
            
            let animation = AnimationType.from(direction: .right, offset: 10.0)
            self.tableView?.animateViews(
                animations: [animation],
                initialAlpha: 0.0,
                finalAlpha: 1.0,
                delay: 0.0,
                duration: 0.3,
                animationInterval: 0.1,
                completion: nil
            )
        }
        
        let fail: (NSError) -> Void = { [unowned self] (error) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.endRefreshing()
            }
            
            if let identifier = self.analyticsIdentifier {
                Answers.logCustomEvent(
                    withName: "request_failed",
                    customAttributes: [
                        "service": "\(identifier)_fetch",
                        "error-debug": error.debugDescription,
                        "error-localized": error.localizedDescription
                    ]
                )
            }
            
            self.showControllerWithError(error)
        }
        
        ds.fetchNews(success: success, fail: fail)
    }

    func setupPullToRefreshControl() {
        //  Setup refresh control
        let refreshCtrl = UIRefreshControl()
        tableView.refreshControl = refreshCtrl
        
        refreshCtrl.tintColor = UIColor(red: 0.99, green: 0.29, blue: 0.39, alpha: 1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchNews), for: .valueChanged)
        
        //  Had to set content offset because of UIRefreshControl bug
        //  http://stackoverflow.com/a/31224299/994129
        tableView.contentOffset = CGPoint(x: 0, y: -refreshCtrl.frame.size.height)
    }
    
    func filterButtonTapped() {
        performSegue(withIdentifier: "filter", sender: self)
    }
    
    private func setupFilterButtonItem() {
        let filterImage = UIImage(named: "filter_icon")
        let filterButtonItem = UIBarButtonItem(
                image: filterImage,
                style: .plain,
                target: self,
                action: #selector(filterButtonTapped)
        )
        filterButtonItem.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = filterButtonItem
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: tableView)
        } else {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            longPressRecognizer.delaysTouchesBegan = true
            tableView.addGestureRecognizer(longPressRecognizer)
        }
        
        guard let ds = self.newsDataSource else {
            return
        }
        
        if ds.shouldDisplayPullToRefreshControl {
            setupPullToRefreshControl()
        }
        
        if ds.isFilterEnabled {
            setupFilterButtonItem()
        }
        
        self.fetchNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let identifier = analyticsIdentifier {
            Answers.logCustomEvent(withName: "\(identifier)_appear", customAttributes: nil)
        }
    }
    
    @IBAction func unwindToNews(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? ReactionPickerViewController else {
            return
        }
        
        guard let currentNews = vc.news,
            let selectedReaction = vc.selectedReaction else {
                return
        }
        
        let success: (URLResponse?, News?) -> Void = { [unowned self] (_, updatedNews) in
            guard let n = updatedNews else {
                return
            }
            self.addReaction(selectedReaction, toNews: n)
        }
        
        let fail: (Error) -> Void = { [unowned self] err in
            
            let error = err as NSError
            
            self.showControllerWithError(error)
            
            Answers.logCustomEvent(
                withName: "request_failed",
                customAttributes: [
                    "service": "POST-reactions",
                    "error-debug": error.debugDescription,
                    "error-localized": error.localizedDescription
                ]
            )
        }
        
        reactionsService.postReaction(
            selectedReaction,
            atPost: currentNews.identifier!,
            success: success,
            fail: fail
        )
    }
    
    @IBAction func unwindFromFilter(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? FilterViewController else {
            return
        }
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        
        case "dismiss":
            return
            
        case "sourcesApply":
            guard let dataSource = vc.filterSourcesDataSource else {
                return
            }
            
            userSettingsManager.whitelistedSources = dataSource.selectedSources
            
            filteredNewsViewModels = newsViewModels.filter { dataSource.selectedSources.contains($0.source!) }
            UIView.transition(
                with: tableView,
                duration: 0.30,
                options: .transitionCrossDissolve,
                animations: {self.tableView.reloadData()},
                completion: nil
            )
            return
            
        case "categorySelected":
            guard let dataSource = vc.filterCategoriesDataSource else {
                return
            }
            
            if dataSource.selectedCategory == nil {
                filteredNewsViewModels = newsViewModels
            } else {
                filteredNewsViewModels = newsViewModels.filter { $0.news.category == dataSource.selectedCategory }
            }
            
            self.tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            
            UIView.transition(
                with: tableView,
                duration: 0.30,
                options: .transitionCrossDissolve,
                animations: {},
                completion: nil
            )
            return
            
        default:
            return
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewsViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as? NewsTableViewCell else {
                return UITableViewCell()
        }
        
        let viewModel = filteredNewsViewModels[indexPath.row]
        
        cell.titleLabel.text = viewModel.title
        cell.sourceLabel.attributedText = viewModel.attributedSource
        cell.timeLabel.text = viewModel.timeString
        cell.reactionsDataSource = viewModel
        cell.reactionsDelegate = viewModel
        cell.viewModel = viewModel
        
        cell.newsImageView.contentMode = .center
        
        if let imgURL = viewModel.imageURL {
            cell.newsImageView.isHidden = false
            cell.newsImageView.sd_setImage(
                with: imgURL,
                placeholderImage: UIImage(named: "icon_placeholder_small"),
                options: [],
                completed: { (_, error, _, _) in
                    
                    if error != nil {
                        return
                    }
                    
                    cell.newsImageView.contentMode = .scaleAspectFill
            })
        } else {
            cell.newsImageView.isHidden = true
        }
        
        cell.reactionsCollectionView.isHidden = !viewModel.shouldShowReactions
        cell.reactionsHeightConstraint.constant = cell.reactionsCollectionView.isHidden ? 0 : 30
        cell.addReactionButton.isHidden = viewModel.shouldShowReactions
        cell.reactionsCollectionView.reloadData()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = filteredNewsViewModels[indexPath.row].news
        openNews(n)
        
        Answers.logContentView(
            withName: n.title ?? "no_title",
            contentType: "news",
            contentId: n.url?.absoluteString ?? "no_url",
            customAttributes: [
                "source": n.source ?? "no_source"
            ]
        )
    }
    
    // MARK: NewsCellViewModelDelegate
    
    func newsViewModel(_ viewModel: NewsCellViewModel, didSelectReaction reaction: Reaction) {

        let success: (URLResponse?, News?) -> Void = { [unowned self] (response, updatedNews) in
            guard let n = updatedNews else {
                return
            }
            self.addReaction(reaction.reaction, toNews: n)
        }
        
        let fail: (Error) -> Void = { [unowned self] (err) in
            self.showControllerWithError(err as NSError)
        }
        
        reactionsService.postReaction(
            reaction.reaction,
            atPost: viewModel.news.identifier!,
            success: success,
            fail: fail
        )
    }
    
    func newsViewModelDidSelectReactionPicker(_ viewModel: NewsCellViewModel) {
        performSegue(withIdentifier: "reaction", sender: viewModel)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DimPresentAnimationController()
        animator.isPresenting = true
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DimPresentAnimationController()
    }
    
    // MARK: SFSafariViewControllerDelegate
    func safariViewController(_ controller: SFSafariViewController,
                              activityItemsFor URL: URL,
                              title: String?) -> [UIActivity] {
        
        guard let n = self.selectedNews else {
            return []
        }
        
        let activity = ShareCanillitapActivity(withNews: n)
        return [activity]
    }
    
    // MARK: UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: tableView.convert(location, from: view)) else {
            return nil
        }
        
        let news = filteredNewsViewModels[indexPath.row].news
        
        let storyboard = UIStoryboard(name: "NewsPreview", bundle: nil)
        let vc: NewsPreviewViewController? = storyboard.instantiateInitialViewController() as? NewsPreviewViewController
        vc?.news = news
        vc?.newsViewController = self
        vc?.preferredContentSize = CGSize(width: 300, height: 300)
        selectedNews = news
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let url = selectedNews?.url else {
            return
        }
        
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - TabbedViewController
    func tabbedViewControllerWasDoubleTapped() {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
}
