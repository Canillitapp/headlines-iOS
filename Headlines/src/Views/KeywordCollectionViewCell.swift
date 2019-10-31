//
//  KeywordCollectionViewCell.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/13/16.
//  Copyright © 2016 Ezequiel Becerra. All rights reserved.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsQuantityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var reactionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.alpha = 0.87
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.backgroundColor = UIColor.white.cgColor
        contentView.layer.borderColor = UIColor.tertiarySystemFill.cgColor
        contentView.layer.borderWidth = 1

        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.10
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
