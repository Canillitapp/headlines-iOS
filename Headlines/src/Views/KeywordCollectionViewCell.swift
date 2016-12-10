//
//  KeywordCollectionViewCell.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/13/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsQuantityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
}
