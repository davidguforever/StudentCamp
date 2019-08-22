//
//  Pro+Ext.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/4/15.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func toImage() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        self.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

public extension CAShapeLayer {
    static func closeShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: edgeLength, y: edgeLength))
        linePath.move(to: CGPoint(x: 0, y: edgeLength))
        linePath.addLine(to: CGPoint(x: edgeLength, y: 0))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.darkGray.cgColor
        elementBorder.lineWidth = 2
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    /// 返回Layer
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func backShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: edgeLength / 3 * 1.57, y: 0))      //1.62
        linePath.addLine(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.move(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.addLine(to: CGPoint(x: edgeLength / 3 * 1.57, y: edgeLength))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.clear.cgColor
        elementBorder.lineWidth = 2
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        
        elementFill.strokeColor = fillColor.cgColor
        
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    /// 确认Layer （勾）
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func confirmShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: edgeLength * 0.47))
        linePath.addLine(to: CGPoint(x: edgeLength * 0.32, y: edgeLength * 0.88))
        linePath.move(to: CGPoint(x: edgeLength * 0.32, y: edgeLength * 0.88))
        linePath.addLine(to: CGPoint(x:  edgeLength * 0.96, y: edgeLength * 0.18))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.darkGray.cgColor
        elementBorder.lineWidth = 2.5
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }
    
    
    /// 加号Layer
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
    static func plusShape(edgeLength: CGFloat, fillColor: UIColor = .white) -> CAShapeLayer {
        
        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: edgeLength + 4, height: edgeLength + 4)
        container.frame.origin = CGPoint.zero
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: edgeLength / 2, y: 0))
        linePath.addLine(to: CGPoint(x: edgeLength / 2, y: edgeLength))
        linePath.move(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.addLine(to: CGPoint(x: edgeLength , y: edgeLength / 2))
        
        let elementBorder = CAShapeLayer()
        elementBorder.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementBorder.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementBorder.lineCap = CAShapeLayerLineCap.round
        elementBorder.path = linePath.cgPath
        elementBorder.strokeColor = UIColor.clear.cgColor
        elementBorder.lineWidth = 2.5
        
        let elementFill = CAShapeLayer()
        elementFill.bounds.size = CGSize(width: edgeLength, height: edgeLength)
        elementFill.position = CGPoint(x: container.bounds.midX, y: container.bounds.midY)
        elementFill.lineCap = CAShapeLayerLineCap.round
        elementFill.path = linePath.cgPath
        
        elementFill.strokeColor = fillColor.cgColor
        elementFill.lineWidth = 2
        
        container.addSublayer(elementBorder)
        container.addSublayer(elementFill)
        
        return container
    }

}



public extension LazyMapCollection  {
    
    func toArray() -> [Element] {
        return Array(self)
    }
}
