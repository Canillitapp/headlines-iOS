//
//  NewsCellModelView.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/1/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

protocol NewsCellViewModelDelegate: class {
    func newsViewModel(_ viewModel: NewsCellViewModel, didSelectReaction reaction: Reaction)
    func newsViewModelDidSelectReactionPicker(_ viewModel: NewsCellViewModel)
}

class NewsCellViewModel: NSObject,
                        UICollectionViewDataSource,
                        UICollectionViewDelegate,
                        UICollectionViewDelegateFlowLayout {

    var news: News

    var dateStyle: DateFormatter.Style?

    var timeString: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = dateStyle ?? .none
        timeFormatter.timeStyle = .short
        return timeFormatter.string(from: news.date)
    }

    var title: String? {
        return news.title
    }

    var source: String? {
        return news.source
    }

    var attributedSource: NSAttributedString? {
        let attributedSource = NSMutableAttributedString()

        if news.source != nil {
            let tmp = NSAttributedString(string: news.source!)
            attributedSource.append(tmp)
        }

        if news.category != nil {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor(white: 0.75, alpha: 1)]
            let tmp = NSAttributedString(string: " (\(news.category!))", attributes: attributes)
            attributedSource.append(tmp)
        }

        return attributedSource
    }

    var imageURL: URL? {
        return news.imageUrl
    }

    var shouldShowReactions: Bool {
        guard let r = news.reactions else {
            return false
        }

        return r.count > 0
    }

    weak var delegate: NewsCellViewModelDelegate?

    init(news: News) {
        self.news = news
        super.init()
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = news.reactions?.count else {
            return 1
        }

        return count+1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let reactions = news.reactions else {
            return UICollectionViewCell()
        }

        if indexPath.row >= reactions.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionCell", for: indexPath)
            cell.layer.borderColor = UIColor(white: 236/255.0, alpha: 1).cgColor

            if let c = cell as? ReactionCollectionViewCell {
                let r = reactions[indexPath.row]
                c.reactionLabel.text = r.reactionString
            }
            return cell
        }
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard indexPath.row < (news.reactions?.count)!,
            let r = news.reactions?[indexPath.row] else {
            return CGSize(width: 40, height: 30)
        }

        let size = CGSize(width: Double.greatestFiniteMagnitude, height: 30)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

        let width = NSString(string: r.reactionString).boundingRect(with: size,
                                                                    options: options,
                                                                    attributes: attributes,
                                                                    context: nil).size.width
        return CGSize(width: width + 10, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row >= (news.reactions?.count)! {
            if let d = delegate {
                d.newsViewModelDidSelectReactionPicker(self)
            }

            return
        }

        guard let r = news.reactions?[indexPath.row] else {
            return
        }

        if let d = delegate {
            d.newsViewModel(self, didSelectReaction: r)
        }
    }
}
