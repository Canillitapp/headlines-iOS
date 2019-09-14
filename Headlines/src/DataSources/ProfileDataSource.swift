//
//  ProfileDataSource.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 11/11/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import Foundation
import UIKit

class ProfileDataSource: NSObject, UICollectionViewDataSource {
    let reactionsService = ReactionsService()
    let interestsService = InterestsService()

    var reactions = [Reaction]()
    var interests = [Interest]()
    var error: Error?

    func fetchProfileData (success: ((_ interests: [Interest], _ reactions: [Reaction]) -> Void)?,
                           fail: ((_ error: Error) -> Void)?) {

        let group = DispatchGroup()
        let queue = DispatchQueue(label: "profile data source")

        group.enter()
        let reactionsHandler: ((Result <[Reaction], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let reactions):
                self?.reactions.removeAll()
                self?.reactions.append(contentsOf: reactions)
                group.leave()

            case .failure(let error):
                self?.error = error
                group.leave()
            }
        }
        reactionsService.getReactions(handler: reactionsHandler)

        group.enter()
        let interestsHandler: ((Result <[Interest], Error>) -> Void) = { [weak self] result in
            switch result {
            case .success(let interests):
                self?.interests.removeAll()
                self?.interests.append(contentsOf: interests)
                group.leave()

            case .failure(let error):
                self?.error = error
                group.leave()
            }
        }
        interestsService.getInterests(handler: interestsHandler)

        group.notify(queue: queue) { [unowned self] in
            if let error = self.error, let fail = fail {
                DispatchQueue.main.async {
                    fail(error)
                }
                return
            }

            if let success = success {
                DispatchQueue.main.async {
                    success(self.interests, self.reactions)
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return interests.count
        case 1:
            return reactions.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interest_cell", for: indexPath) as? LabelCollectionViewCell else {
                return UICollectionViewCell()
            }
            let interest = interests[indexPath.row]
            cell.label.text = interest.name
            cell.label.textColor = UIColor.black
            cell.backgroundColor = UIColor(white: 240/255.0, alpha: 1)

            cell.normalTextColor = UIColor.black
            cell.normalBackgroundColor = UIColor(white: 240/255.0, alpha: 1)
            cell.selectedTextColor = UIColor.black
            cell.selectedBackgroundColor = UIColor(white: 240/255.0, alpha: 1)

            return cell

        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reaction_cell", for: indexPath) as? ProfileReactionCollectionViewCell else {
                return UICollectionViewCell()
            }
            let reaction = reactions[indexPath.row]
            cell.emojiLabel.text = reaction.reaction

            if let n = reaction.news {
                cell.label.text = n.title
                cell.imageView.sd_setImage(with: n.imageUrl)
            }

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "header",
                                                                               for: indexPath)
            as? SectionLabelHeaderCollectionReusableView {

            switch indexPath.section {
            case 0:
                sectionHeader.label.text = "Intereses"
            case 1:
                sectionHeader.label.text = "Reacciones"
            default: break
            }

            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
