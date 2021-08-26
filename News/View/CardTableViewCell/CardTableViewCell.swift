//
//  CardTableViewCell.swift
//  News
//
//  Created by Ahmd Amr on 26/08/2021.
//  Copyright © 2021 ahmdamr. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak private var cardImageView: UIImageView!
    @IBOutlet weak private var sourceNameLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
