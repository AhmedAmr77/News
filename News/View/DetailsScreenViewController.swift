//
//  DetailsScreenViewController.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsScreenViewController: UIViewController {
    
    @IBOutlet weak private var articleImageView: UIImageView!
    @IBOutlet weak private var outterContainerView: UIView!
    @IBOutlet weak private var innerContainerView: UIView!
    @IBOutlet weak private var articleSourceNameLabel: UILabel!
    @IBOutlet weak private var articleTitleLabel: UILabel!
    @IBOutlet weak private var articleDescriptionLabel: UILabel!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        displayData()
    }
}

extension DetailsScreenViewController {
    private func initView() {
        outterContainerView.layer.cornerRadius = 15
        innerContainerView.layer.cornerRadius = 15
        
        view.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = #colorLiteral(red: 0.03529411765, green: 0.368627451, blue: 0.6705882353, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.03529411765, green: 0.368627451, blue: 0.6705882353, alpha: 1)
    }
    private func displayData() {
        articleImageView.sd_setImage(with: URL(string: article.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
        articleSourceNameLabel.text = article.source.name
        articleTitleLabel.text = article.title
        articleDescriptionLabel.text = article.description
    }
}
