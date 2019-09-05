//
//  ThemeTableViewCell.swift
//  CampClub
//
//  Created by HP on 2019/9/5.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ThemeTableViewCell: UITableViewCell ,ThemeProtocol{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addThemeObserver()
        segementControl.tintColor=MTTheme.getMainColor()
    }
    override func updateTheme() {
        super.updateTheme()
        segementControl.tintColor=MTTheme.getMainColor()
    }
    @IBOutlet weak var segementControl: UISegmentedControl!
    
    @IBAction func SegmentChange(_ sender: UISegmentedControl) {
        let value=sender.selectedSegmentIndex
        switch value {
        case 0:
            ThemeManager.defaults.setTheme("boy")
        case 1:
            ThemeManager.defaults.setTheme("girl")
        default:
            ThemeManager.defaults.setTheme("boy")
        }
        ThemeManager.defaults.updatetheme()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
