//
//  CellView.swift
//  CampClub
//
//  Created by HP on 2019/9/6.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class SectorCellView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

    func drawSector(sectorCenter:CGPoint,radius:Double,color:UIColor,text:String){
        let color = color
        color.set() // 设置线条颜色
        
        let aPath = UIBezierPath(arcCenter: sectorCenter, radius: radius.cgFloat,
                                 startAngle: CGFloat(radius/2), endAngle: (CGFloat)((radius)/2*Double.pi/180), clockwise: true)
        aPath.addLine(to: CGPoint(x:150, y:150))
        aPath.close()
        aPath.lineWidth = 5.0 // 线条宽度
        
        //    aPath.stroke() // Draws line 根据坐标点连线，不填充
        aPath.fill() // Draws line 根据坐标点连线，填充
    }
    override func draw(_ rect: CGRect) {
        
    }

}
