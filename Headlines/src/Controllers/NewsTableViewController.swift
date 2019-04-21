//
//  NewsTableViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit
import SafariServices

class NewsTableViewController: UIViewController {

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
    var hasRegisteredPreview = false
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

    var tableView: UITableView?

    var lastPage: Int = 1
    var isFetchingNews: Bool = false
    var canFetchMoreNews: Bool = true

    func showControllerWithError(_ error: NSError) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Sorry",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {
        case "reaction":
            prepareReaction(with: segue, sender: sender)

        case "filter":
            prepareFilter(with: segue)

        default:
            return
        }
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)

        guard let tableView = tableView else {
            return
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Constraints
        let leftConstraint = NSLayoutConstraint(item: tableView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)

        let topConstraint = NSLayoutConstraint(item: tableView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)

        let rightConstraint = NSLayoutConstraint(item: tableView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)

        let bottomConstraint = NSLayoutConstraint(item: tableView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)

        view.addConstraints([leftConstraint, topConstraint, rightConstraint, bottomConstraint])

        tableView.delegate = self
        tableView.dataSource = self

        // Register custom cell
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        guard let ds = self.newsDataSource else {
            return
        }

        if ds.shouldDisplayPullToRefreshControl {
            setupPullToRefreshControl()
        }

        if ds.isFilterEnabled {
            setupFilterButtonItem()
        }

        self.fetchReload()
    }
}

// MARK: - UITableViewDataSource
extension NewsTableViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewsViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard
            let newsDataSource = newsDataSource,
            newsDataSource.isPaginationEnabled == true,
            indexPath.row >= filteredNewsViewModels.count - 15,
            isFetchingNews == false,
            canFetchMoreNews == true else {

                return
        }

        fetch(mode: .nextPage)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate
extension NewsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let n = filteredNewsViewModels[indexPath.row].news
        openNews(n)
    }
}
