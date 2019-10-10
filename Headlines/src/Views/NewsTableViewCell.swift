//
//  NewsTableViewCell.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 11/16/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var reactionsCollectionView: UICollectionView!
    @IBOutlet weak var reactionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addReactionButton: UIButton!

    weak var reactionsDataSource: UICollectionViewDataSource? {
        didSet {
            reactionsCollectionView?.dataSource = reactionsDataSource
        }
    }

    weak var reactionsDelegate: UICollectionViewDelegate? {
        didSet {
            reactionsCollectionView?.delegate = reactionsDelegate
        }
    }

    weak var viewModel: NewsCellViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()

        let reactionNib = UINib(nibName: "ReactionCollectionViewCell", bundle: nil)
        reactionsCollectionView.register(reactionNib, forCellWithReuseIdentifier: "reactionCell")

        let addReactionNib = UINib(nibName: "AddReactionCollectionViewCell", bundle: nil)
        reactionsCollectionView.register(addReactionNib, forCellWithReuseIdentifier: "addCell")

        #if targetEnvironment(macCatalyst)
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        sourceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        timeLabel.font = UIFont.systemFont(ofSize: 18)
        #endif
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

    @IBAction func reactionButtonPressed(_ sender: Any) {
        if let d = viewModel?.delegate {
            d.newsViewModelDidSelectReactionPicker(viewModel!)
        }
    }
}
