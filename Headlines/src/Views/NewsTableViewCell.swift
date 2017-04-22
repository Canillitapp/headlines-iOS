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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
}
