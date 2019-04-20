//
//  TrendingCardsViewController+CollectionView.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 24/06/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UICollectionView misc
extension TrendingCardsViewController {

    func updateFooterView() {
        if let view = footerView {
            let shouldShowFooter = topics.count > 0 && newsDataTask?.state == .running
            view.isHidden = !shouldShowFooter
        }
    }

    private func setupFooter() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let footerNib = UINib(nibName: "NewsFooterView", bundle: nil)
        collectionView.register(footerNib,
                                forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter",
                                withReuseIdentifier: "footer")
        flowLayout.footerReferenceSize = CGSize(width: collectionView.bounds.size.width, height: 50)

    }

    private func setupHeader() {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        let headerNib = UINib(nibName: "CategoriesHeaderView", bundle: nil)
        collectionView.register(headerNib,
                                forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader",
                                withReuseIdentifier: "categories")
        flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.size.width, height: 90)
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

    func setupCollectionView() {
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

        setupHeader()
        setupFooter()
    }
}

// MARK: - UICollectionViewDataSource
extension TrendingCardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.topics.count
    }

    func collectionView(_ collectionView: UICollectionView,
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        cell.dateLabel.text = dateFormatter.string(from: firstNews.date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        cell.timeLabel.text = timeFormatter.string(from: firstNews.date)

        cell.titleLabel.text = topic.name
        cell.bodyLabel.text = firstNews.title
        cell.sourceLabel.text = firstNews.source
        cell.newsQuantityLabel.text = "\(news.count) noticias"
        cell.reactionLabel.text = topic.representativeReaction?.reaction ?? ""

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

    private func footer(from collectionView: UICollectionView,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = footerView else {
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionFooter",
                                                                         withReuseIdentifier: "footer",
                                                                         for: indexPath)
            updateFooterView()
            return footerView!
        }
        return view
    }

    private func header(from collectionView: UICollectionView,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader",
                                                                         withReuseIdentifier: "categories",
                                                                         for: indexPath)

        guard let view = headerView as? CategoriesHeaderView else {
            return headerView
        }

        view.viewModel = categoriesContainerViewModel
        return view
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "UICollectionElementKindSectionFooter" {
            return footer(from: collectionView, at: indexPath)
        } else {
            return header(from: collectionView, at: indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TrendingCardsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        performSegue(withIdentifier: "news", sender: topic)
    }
}
