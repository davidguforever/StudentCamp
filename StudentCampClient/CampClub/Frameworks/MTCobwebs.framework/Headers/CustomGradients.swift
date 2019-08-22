//
//  CustomGradients.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//
import UIKit
import QuartzCore
import Foundation


/// 渐变Layer
///
/// Usage:
/// ```
///     // degree for radian direction supported
///     let customLayer = MTGradients.linear(to: .degree(-225), colors: [0x231557, 0x44107A, 0xFF1361, 0xFFF800], locations: [0.0, 0.29, 0.67, 1.0]) // Fabled Sunset
///     view.layer.addSubLayer(customLayer)
///
///
///     let layer = CALayer()
///     layer.backgroundColor = UIColor(0xe4e4e1).cgColor
///     layer.addSublayer(MTGradients.radial(startPoint: CGPoint(x: 0.5, y: 0.0),
///                              endPoint: CGPoint(x: 1.5, y: 1.0),
///                              colors: [UIColor(0xffffff, a: 0.03).cgColor, UIColor(0x000000, a: 0.03).cgColor],
///                              locations: [0.0, 1.0]))
///     layer.addSublayer(MTGradients.linear(to: .top,
///                              colors: [UIColor(0xffffff, a: 0.1).cgColor, UIColor(0x8F989D, a: 0.6).cgColor],
///                              locations: [0.0, 1.0],
///                              filter: CIFilter(name: "CIMultiplyBlendMode")))
///     view.layer.addSubLayer(customLayer)
///
/// ```
struct MTGradients {
    
    /// 线性渐变Layer
    ///
    /// - Parameters:
    ///   - direction: 方向
    ///   - colors: 颜色Int数组
    ///   - locations: 位置  0~1
    ///   - filter: CIFilter
    /// - Returns: CAGradientLayer
    public static func linear(to direction: MTDirection, colors: [Int], locations: [NSNumber], filter: CIFilter? = nil) -> CAGradientLayer {
        return linear(to: direction, colors: colors.map { color in color.cgColor }, locations: locations)
    }
    
    /// 线性渐变Layer
    ///
    /// - Parameters:
    ///   - direction: 方向
    ///   - colors: 颜色数组
    ///   - locations: 位置  0~1
    ///   - filter: CIFilter
    /// - Returns: CAGradientLayer
    public static func linear(to direction: MTDirection, colors: [CGColor], locations: [NSNumber], filter: CIFilter? = nil) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = direction.startPoint
        layer.endPoint = direction.endPoint
        layer.colors = colors
        layer.locations = locations
        if let filter = filter {
            layer.backgroundFilters = [filter]
        }
        return layer
    }
    /// 弧形渐变Layer
    ///
    /// - Parameters:
    ///   - startPoint: 开始点
    ///   - endPoint: 结束点
    ///   - colors: 颜色Int
    ///   - locations: 位置  0~1
    ///   - filter: CIFilter
    /// - Returns: CAGradientLayer
    public static func radial(startPoint: CGPoint, endPoint: CGPoint, colors: [Int], locations: [NSNumber], filter: CIFilter? = nil) -> CAGradientLayer {
        return radial(startPoint: startPoint, endPoint: endPoint, colors: colors.map { color in color.cgColor}, locations: locations)
    }
    /// 弧形渐变Layer
    ///
    /// - Parameters:
    ///   - startPoint: 开始点
    ///   - endPoint: 结束点
    ///   - colors: 颜色数组
    ///   - locations: 位置  0~1
    ///   - filter: CIFilter
    /// - Returns: CAGradientLayer
    public static func radial(startPoint: CGPoint, endPoint: CGPoint, colors: [CGColor], locations: [NSNumber], filter: CIFilter? = nil) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.type = .radial
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        layer.colors = colors
        layer.locations = locations
        if let filter = filter {
            layer.backgroundFilters = [filter]
        }
        return layer
    }
    

}

extension Int {
    var color: UIColor {
        return UIColor(self)
    }
    var cgColor: CGColor {
        return UIColor(self).cgColor
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 255, "Invalid alpha component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(_ rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: a
        )
    }
}



/// 渐变方向
///
/// - top: 向上
/// - left: 向左
/// - right: 向右
/// - bottom: 向下
/// - degree: 以中心点弧形角度渐变
public enum MTDirection {
    case top
    case left
    case right
    case bottom
    case degree(CGFloat)
}



public extension MTDirection {
    public var startPoint: CGPoint {
        switch self {
        case .top:
            return CGPoint(x: 0.5, y: 1.0)
        case .left:
            return CGPoint(x: 1.0, y: 0.5)
        case .right:
            return CGPoint(x: 0.0, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 0.0)
        case .degree(let degree):
            let radian = degree * .pi / 180
            return CGPoint(x: 0.5 * (cos(radian) + 1), y: 0.5 * (1 - sin(radian)))
        }
    }
    
    public var endPoint: CGPoint {
        switch self {
        case .top:
            return CGPoint(x: 0.5, y: 0.0)
        case .left:
            return CGPoint(x: 0.0, y: 0.5)
        case .right:
            return CGPoint(x: 1.0, y: 0.5)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        case .degree(let degree):
            let radian = degree * .pi / 180
            return CGPoint(x: 0.5 * (cos(radian + .pi) + 1), y: 0.5 * (1 + sin(radian)))
        }
    }
}

