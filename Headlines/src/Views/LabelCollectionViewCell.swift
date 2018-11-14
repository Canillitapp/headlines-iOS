//
//  LabelCollectionViewCell.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class LabelCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    
    var normalTextColor = UIColor.white {
        didSet {
            if !isSelected {
                label.textColor = normalTextColor
            }
        }
    }
    
    var normalBackgroundColor = UIColor.init(white: 216/255.0, alpha: 1) {
        didSet {
            if !isSelected {
                backgroundColor = normalBackgroundColor
            }
        }
    }
    
    var selectedTextColor = UIColor.white {
        didSet {
            if isSelected {
                label.textColor = normalTextColor
            }
        }
    }
    
    var selectedBackgroundColor = UIColor(red: 252/255.0, green: 75/255.0, blue: 99/255.0, alpha: 1) {
        didSet {
            if isSelected {
                backgroundColor = normalTextColor
            }
        }
    }
    
    static let defaultInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let defaultFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = selectedBackgroundColor
                label.textColor = selectedTextColor
            } else {
                backgroundColor = normalBackgroundColor
                label.textColor = normalTextColor
            }
        }
    }
    
    private func setupLabel() {
        label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = LabelCollectionViewCell.defaultFont
        label.textColor = normalTextColor
        self.addSubview(label)
        
        let leftConstraint = NSLayoutConstraint(item: label,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: LabelCollectionViewCell.defaultInsets.left)
        
        let topConstraint = NSLayoutConstraint(item: label,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: LabelCollectionViewCell.defaultInsets.top)
        
        let rightConstraint = NSLayoutConstraint(item: label,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: -LabelCollectionViewCell.defaultInsets.right)
        
        let bottomConstraint = NSLayoutConstraint(item: label,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: -LabelCollectionViewCell.defaultInsets.bottom)
        bottomConstraint.priority = UILayoutPriority.init(999)
        
        let constraints = [leftConstraint, topConstraint, rightConstraint, bottomConstraint]
        self.addConstraints(constraints)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        
        layer.cornerRadius = 10
        backgroundColor = normalBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func size(with text: String) -> CGSize {
        
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.text = text
        label.font = defaultFont
        
        var size = label.sizeThatFits(.zero)
        size.width += defaultInsets.left + defaultInsets.right
        size.height += defaultInsets.top + defaultInsets.bottom
        
        return size
    }
}
