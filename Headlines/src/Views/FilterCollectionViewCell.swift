//
//  FilterCollectionViewCell.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 9/8/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(red: 246 / 255.0,
                                          green: 35 / 255.0,
                                          blue: 84 / 255.0,
                                          alpha: 1)
            } else {
                backgroundColor = UIColor(white: 216 / 255.0, alpha: 1)
            }
        }
    }
}
