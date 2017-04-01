//
//  ReactionPickerViewController.swift
//  Headlines
//
//  Created by Ezequiel Becerra on 4/1/17.
//  Copyright © 2017 Ezequiel Becerra. All rights reserved.
//

import UIKit

class ReactionPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var news: News?
    var availableReactions: [String] = [
                                        "😀", "😄", "😆", "😅", "😂", "😊", "😇", "🙂", "🙃", "😍", "😘", "😗", "😜",
                                        "😝", "🤑", "🤓", "😎", "🤡", "🤠", "😏", "😒", "☹️", "😣", "😩", "😡", "😶",
                                        "😐", "😯", "😦", "😵", "😳", "😱", "😨", "😢", "🤤", "😭", "😴", "🙄", "🤔",
                                        "🤥", "😬", "🤐", "🤢", "😷", "🤒", "🤕", "😈", "👿", "💩", "👻", "☠️", "👽",
                                        "👾", "🤖", "🎃", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "👐",
                                        "🙌", "👏", "🙏", "🤝", "👍", "👎", "👊", "🤞", "✌️", "🤘", "👌", "🖖", "💪",
                                        "🖕", "💅", "👳🏽", "👮🏾", "💁🏻", "💁🏻‍♂️", "🙅🏻", "🙅🏻‍♂️", "🤦🏻‍♀️", "🤦🏻‍♂️", "🤷🏻‍♀️", "🤷🏻‍♂️", "👯"
                                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToNews", sender: self)
    }
    
    //  MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //  MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let c = cell as? ReactionCollectionViewCell {
            c.reactionLabel.text = availableReactions[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableReactions.count
    }
}
