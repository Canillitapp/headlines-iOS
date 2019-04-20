//
//  ReviewView.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 13/07/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

protocol ReviewViewDelegate: class {
    func reviewViewDidCancel(_ view: ReviewView)
    func reviewViewDidAccept(_ view: ReviewView)
}

class ReviewView: UIView {
    weak var delegate: ReviewViewDelegate?
    var contentView: UIView?
    let nibName = "ReviewView"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        reviewButton.layer.borderColor = UIColor.white.cgColor
        reviewButton.layer.borderWidth = 1
        reviewButton.layer.cornerRadius = 8

        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 8
    }

    class func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "ReviewView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func reviewButtonPressed(_ sender: Any) {
        let animation = { [unowned self] in
            self.isHidden = true
        }

        let completion: (Bool) -> Void = { [unowned self] (completed) in
            guard let delegate = self.delegate else {
                return
            }

            delegate.reviewViewDidAccept(self)
        }

        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }

    @IBAction func reviewCancelButtonPressed(_ sender: Any) {
        let animation = { [unowned self] in
            self.isHidden = true
        }

        let completion: (Bool) -> Void = { [unowned self] (completed) in
            guard let delegate = self.delegate else {
                return
            }

            delegate.reviewViewDidCancel(self)
        }

        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
}
