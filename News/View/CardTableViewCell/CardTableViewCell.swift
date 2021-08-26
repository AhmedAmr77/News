//
//  CardTableViewCell.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit
import SDWebImage

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak private var cardImageView: UIImageView!
    @IBOutlet weak private var sourceNameLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    var article: Article? {
        didSet {
            cardImageView.sd_setImage(with: URL(string: article?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder"))
            sourceNameLabel.text = article?.source.name
            titleLabel.text = article?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            contentView.layer.cornerRadius = 15.0
    //        containerView.layer.cornerRadius = 15.0
    //        newsImageView.layer.cornerRadius = 15.0
    //        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            backgroundColor = UIColor.clear
    //        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    //        contentView.frame = contentView.frame.inset(by: margins)
            let padding = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            contentView.bounds = bounds.inset(by: padding)
        }
}
