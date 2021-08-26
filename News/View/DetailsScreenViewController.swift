//
//  DetailsScreenViewController.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit

class DetailsScreenViewController: UIViewController {

    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Details: \(article.title)")
        
    }
    
}
