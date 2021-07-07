//
//  ListableViewCell.swift
//  CampClub
//
//  Created by HP on 2019/9/22.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ListableViewCell: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
