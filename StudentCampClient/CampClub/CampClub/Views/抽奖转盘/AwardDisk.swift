//
//  AwardDisk.swift
//  CampClub
//
//  Created by HP on 2019/9/7.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class AwardDisk: UIView {
    
    let arrowView=UIImageView(image: UIImage(named: "arrow"))
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
    }
    public var disk:Disk?=nil
    
    
    func setup(text:[String]){

        for subview in subviews{
            subview.removeFromSuperview()
        }
        disk=Disk(frame: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        disk!.text=text
        addSubview(disk!)
        disk!.initSectors()
        
        arrowView.frame=CGRect(x: radius-22, y: radius-33, width: 44, height: 44)
        addSubview(arrowView)
        
        setNeedsDisplay()
    }
    
    

    
    public func startRotate(rotateAngle:CGFloat,completefunc:(()->())?){
        disk!.startRotate(rotateAngle: rotateAngle, completeFunc: completefunc)

    }
    public func startRotate(finishnum:Int,completefunc:(()->())?){
        disk!.startRotate(rotateAngle: CGFloat(Double.pi*6+angle*Double(finishnum)), completeFunc: completefunc)

    }
    
    public override func draw(_ rect: CGRect) {
        setupCircle()
    }
    
    //画最外面的圆
    private func setupCircle(){
        UIColor.white.set() //圆盘背景颜色
        let circle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius*2, height: radius*2))
        circle.lineWidth=7.0
        circle.fill()
        
    }
}
