//
//  DetailsScreenViewController.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit

class DetailsScreenViewController: UIViewController {
    
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var outterContainerView: UIView!
    @IBOutlet weak var innerContainerView: UIView!
    @IBOutlet weak var articleSourceNameLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Details: \(article.title)")
        
    }
    
}
