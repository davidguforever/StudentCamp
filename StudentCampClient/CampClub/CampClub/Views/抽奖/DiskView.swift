//
//  DiskView.swift
//  CampClub
//
//  Created by HP on 2019/9/6.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class DiskView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.white
        
        let sectorCenter=CGPoint(x: 150,y: 150)
        let sector_num=6
        var sectors:[SectorCellView]

        //测试扇形
        let sectorCell = SectorCellView()
        sectorCell.frame=bounds
        addSubview(sectorCell)
        sectorCell.drawSector(sectorCenter: sectorCenter, radius: 30, color: UIColor.red, text: "a")

    }
 
    
    

}
