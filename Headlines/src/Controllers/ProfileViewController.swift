//
//  ProfileViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/25/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

import Crashlytics
import JGProgressHUD
import SDWebImage
import ViewAnimator

class ProfileViewController: UIViewController, TabbedViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var centerActivityIndicator: UIActivityIndicatorView!
    
    let contentViewsService = ContentViewsService()
    let profileDataSource = ProfileDataSource()
    let newsService = NewsService()
    
    typealias InterestNews = (interest: String, news: [News])
    
    // MARK: Private
    private func trackOpenNews(_ news: News) {
        contentViewsService.postContentView(news.identifier, context: .reactions, success: nil, fail: nil)
    }
    
    func openURL(_ url: URL) {
        guard let shouldOpenNewsInsideApp = UserDefaults.standard.object(forKey: "open_news_inside_app") as? Bool else {
            //  By default, open the news using Safari outside the app
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        
        if shouldOpenNewsInsideApp {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func endRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func startRefreshing() {
        if !ProcessInfo.processInfo.arguments.contains("mockRequests") {
            collectionView.refreshControl?.beginRefreshing()
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
    
    @objc func fetchProfileData() {
        startRefreshing()
        
        let success: (([Interest], [Reaction]) -> Void) = { [unowned self] (interests, reactions) in
            self.endRefreshing()
            self.collectionView.reloadData()
            
            self.centerActivityIndicator.isHidden = true
            
            // animate collection view now that we have content to display
            let animation: () -> Void = { [unowned self] in
                self.collectionView.alpha = 1.0
            }
            
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.curveEaseInOut],
                           animations: animation,
                           completion: nil)
        }
        
        let fail: ((Error) -> Void) = { [unowned self] (error) in
            
            // Either if it fails, we should reset this state.
            self.centerActivityIndicator.isHidden = true
            self.collectionView.alpha = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.endRefreshing()
            }
            self.showControllerWithError(error as NSError)
        }
        
        profileDataSource.fetchProfileData(success: success, fail: fail)
    }
    
    func setupCollectionView() {
        //  Setup refresh control
        let refreshCtrl = UIRefreshControl()
        collectionView.refreshControl = refreshCtrl
        
        refreshCtrl.tintColor = UIColor(red: 0.99, green: 0.29, blue: 0.39, alpha: 1.00)
        refreshCtrl.addTarget(self, action: #selector(fetchProfileData), for: .valueChanged)
        
        //  Had to set content offset because of UIRefreshControl bug
        //  http://stackoverflow.com/a/31224299/994129
        collectionView.contentOffset = CGPoint(x: 0, y: -refreshCtrl.frame.size.height)
        
        collectionView.delegate = self
        collectionView.dataSource = profileDataSource
        
        //  Hide collectionView until we got info fetched for the first time
        collectionView.alpha = 0
        
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "interest_cell")
    }
    
    func handleReactionSelection(_ reaction: Reaction) {
        guard let n = reaction.news else {
            return
        }
        trackOpenNews(n)
        openURL(n.url)
    }
    
    func handleInterestSelection(_ interest: Interest) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        let success: (([News]?) -> Void) = { [unowned self] (news) in
            hud.dismiss()
            
            guard let news = news else {
                return
            }
            
            let interestNews = InterestNews(interest: interest.name, news: news)
            self.performSegue(withIdentifier: "interest_did_select", sender: interestNews)
        }
        
        let fail: ((NSError) -> Void) = { [unowned self] (error) in
            hud.dismiss()
            
            self.showControllerWithError(error as NSError)
        }
        
        _ = newsService.searchNews(interest.name, success: success, fail: fail)
    }
    
    // MARK: Public
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchProfileData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "interest_did_select":
            guard
                let vc = segue.destination as? NewsTableViewController,
                let interestNews = sender as? InterestNews else {
                return
            }
            vc.title = interestNews.interest
            vc.preferredDateStyle = .short
            vc.news = interestNews.news
            
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Answers.logCustomEvent(withName: "profile_appear", customAttributes: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        
        case 0:
            let interest = profileDataSource.interests[indexPath.row]
            handleInterestSelection(interest)
        
        case 1:
            let reaction = profileDataSource.reactions[indexPath.row]
            handleReactionSelection(reaction)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        switch indexPath.section {
        case 1:
            let xInset = collectionView.layoutMargins.left
            let yInset = collectionView.layoutMargins.top
            let cellWidth = collectionView.bounds.insetBy(dx: xInset, dy: yInset).width
            return CGSize(width: cellWidth, height: 60)

        default:
            let text = profileDataSource.interests[indexPath.row].name
            return LabelCollectionViewCell.size(with: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 1:
            return 0
        default:
            return 10
        }
    }
    
    // MARK: - TabbedViewController
    func tabbedViewControllerWasDoubleTapped() {
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
}
