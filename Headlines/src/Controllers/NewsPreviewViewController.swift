//
//  NewsPreviewViewController.swift
//  Canillitapp
//
//  Created by Ezequiel Becerra on 03/03/2018.
//  Copyright © 2018 Ezequiel Becerra. All rights reserved.
//

import UIKit

class NewsPreviewViewController: UIViewController {
    var news: News?
    weak var newsViewController: NewsTableViewController?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.sd_setImage(with: news?.imageUrl)
        titleLabel.text = news?.title
        subtitleLabel.text = news?.source
    }

    override var previewActionItems: [UIPreviewActionItem] {

        let shareAction = UIPreviewAction(title: "Compartir Noticia", style: .default, handler: { (_, _) -> Void in
            guard let n = self.news else {
                return
            }

            UIPasteboard.general.string = ShareCanillitapActivity.canillitappURL(fromNews: n)
        })

        var actions = [shareAction]

        if newsViewController != nil {
            let reactionsAction = UIPreviewAction(title: "Agregar Reacción", style: .default, handler: { (_, _) -> Void in
                guard let n = self.news else {
                    return
                }

                let vm = NewsCellViewModel(news: n)
                self.newsViewController?.performSegue(withIdentifier: "reaction", sender: vm)
            })
            actions.append(reactionsAction)
        }

        return actions
    }
}
