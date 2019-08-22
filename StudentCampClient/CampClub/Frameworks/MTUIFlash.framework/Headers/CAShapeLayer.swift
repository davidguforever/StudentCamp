//
//  UIImage.swift
//  ImageViewer
//
//  Created by Kristian Angyal on 28/07/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

public extension CAShapeLayer {
    
    /// 重播Layer
    ///
    /// - Parameters:
    ///   - fillColor: 颜色
    ///   - triangleEdgeLength: 长度
    /// - Returns: shape layer
    static func replayShape(_ fillColor: UIColor, triangleEdgeLength: CGFloat) -> CAShapeLayer {

        let triangle = CAShapeLayer()
        let altitude = (sqrt(3) / 2) * triangleEdgeLength
        triangle.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: altitude, height: triangleEdgeLength))
        triangle.path = UIBezierPath.equilateralTriangle(triangleEdgeLength).cgPath
        triangle.fillColor = fillColor.cgColor

        return triangle
    }

    /// 播放Layer
    ///
    /// - Parameters:
    ///   - fillColor: 颜色
    ///   - triangleEdgeLength: 长度
    /// - Returns: shape layer
    static func playShape(_ fillColor: UIColor, triangleEdgeLength: CGFloat) -> CAShapeLayer {

        let triangle = CAShapeLayer()
        let altitude = (sqrt(3) / 2) * triangleEdgeLength
        triangle.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: altitude, height: triangleEdgeLength))
        triangle.path = UIBezierPath.equilateralTriangle(triangleEdgeLength).cgPath
        triangle.fillColor = fillColor.cgColor

        return triangle
    }
    
    /// 暂停Layer
    ///
    /// - Parameters:
    ///   - fillColor: 颜色
    ///   - triangleEdgeLength: 长度
    /// - Returns: shape layer
    static func pauseShape(_ fillColor: UIColor, elementSize: CGSize, elementDistance: CGFloat) -> CAShapeLayer {

        let element = CALayer()
        element.bounds.size = elementSize
        element.frame.origin = CGPoint.zero

        let secondElement = CALayer()
        secondElement.bounds.size = elementSize
        secondElement.frame.origin = CGPoint(x: elementSize.width + elementDistance, y: 0)

        [element, secondElement].forEach { $0.backgroundColor = fillColor.cgColor }

        let container = CAShapeLayer()
        container.bounds.size = CGSize(width: 2 * elementSize.width + elementDistance, height: elementSize.height)
        container.frame.origin = CGPoint.zero

        container.addSublayer(element)
        container.addSublayer(secondElement)

        return container
    }
    
    /// 圈Layer
    ///
    /// - Parameters:
    ///   - fillColor: 颜色
    ///   - diameter: 半径
    /// - Returns: shape layer
    static func circle(_ fillColor: UIColor, diameter: CGFloat) -> CAShapeLayer {

        let circle = CAShapeLayer()
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter * 2, height: diameter * 2))
        circle.frame = frame
        circle.path = UIBezierPath(ovalIn: frame).cgPath
        circle.fillColor = fillColor.cgColor

        return circle
    }
    
    /// 圈内播放Layer
    ///
    /// - Parameters:
    ///   - fillColor: 颜色
    ///   - diameter: 半径
    /// - Returns: shape layer
    static func circlePlayShape(_ fillColor: UIColor, diameter: CGFloat) -> CAShapeLayer {

        let circle = CAShapeLayer()
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter))
        circle.frame = frame
        let circlePath   = UIBezierPath(ovalIn: frame)
        let trianglePath = UIBezierPath.equilateralTriangle(diameter / 2, shiftBy: CGPoint(x: diameter / 3, y: diameter / 4))

        circlePath.append(trianglePath)
        circle.path = circlePath.cgPath
        circle.fillColor = fillColor.cgColor

        return circle
    }
    
    /// 关闭Layer
    ///
    /// - Parameters:
    ///   - edgeLength: 长度
    ///   - fillColor: 颜色
    /// - Returns: shape layer
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
        linePath.move(to: CGPoint(x: edgeLength / 3 * 1.62, y: 0))
        linePath.addLine(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.move(to: CGPoint(x: 0, y: edgeLength / 2))
        linePath.addLine(to: CGPoint(x: edgeLength / 3 * 1.62, y: edgeLength))
        
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
