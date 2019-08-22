//  UIView+Shadow.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit


/// 阴影
public struct Shadow {
    /// 颜色
    var color : UIColor
    /// 偏移量
    var offset : UIOffset
    /// 透明度
    var opacity : CGFloat
    /// 圆角
    var radius : CGFloat
    
    
    /// Init
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - offset: 偏移量
    ///   - opacity: 透明度
    ///   - radius: 圆角
    public init( color : UIColor = UIColor.clear, offset : UIOffset = UIOffset.zero, opacity : CGFloat = 0, radius : CGFloat = 0) {
        self.color = color
        self.offset = offset
        self.opacity = opacity
        self.radius = radius
    }
    // MARK: Statics
    
    /// None Shadow
    public static let None = Shadow()
    /// Light Shadow
    public static let Light = Shadow(color: UIColor.black, offset: UIOffset.zero, opacity: 0.3, radius: 1)
    /// Dark Shadow
    public static let Dark = Shadow(color: UIColor.black, offset: UIOffset(horizontal: 2, vertical: 2), opacity: 0.8, radius: 3)
}

//MARK: - Equatable

extension Shadow : Equatable {}

/// 阴影 `Shadow` 对比
///
/// - Parameters:
///   - lhs: Shadow
///   - rhs: Shadow
/// - Returns: 是否完全相等
public func == (lhs: Shadow, rhs:Shadow) -> Bool
{
    return lhs.color == rhs.color && lhs.offset == rhs.offset && lhs.opacity == rhs.opacity && lhs.radius == rhs.radius
}

// MARK: - CustomDebugStringConvertible

extension Shadow : CustomDebugStringConvertible
{
    public var debugDescription : String { return "Shadow(offset: \(offset), opacity: \(opacity), radius: \(radius), color: \(color))" }
}



public extension UIView
{
    // MARK: - UIView Shadow
    
    /// 阴影颜色
    @IBInspectable
    public var shadowColor : UIColor?
        {
        set { layer.shadowColor = newValue?.cgColor }
        get
        {
            if let shadowCgColor = layer.shadowColor
            {
                return UIColor(cgColor: shadowCgColor)
            }
            return nil
        }
    }
    
    /// 阴影偏移量
    @IBInspectable
    public var shadowOffset : CGSize
        {
        set { layer.shadowOffset = newValue }
        get { return layer.shadowOffset }
    }
    
    /// 阴影透明度
    @IBInspectable
    public var shadowOpacity : CGFloat
        {
        set { layer.shadowOpacity = Float(newValue) }
        get { return CGFloat(layer.shadowOpacity) }
    }
    
    /// 阴影圆角
    @IBInspectable
    public var shadowRadius : CGFloat
        {
        set { layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    /// 阴影 set/get
    public var shadow : Shadow
        {
        set
        {
            shadowColor = newValue.color
            shadowOffset = CGSize(width: newValue.offset.horizontal, height: newValue.offset.vertical)
            shadowOpacity = newValue.opacity
            shadowRadius = newValue.radius
        }
        
        get
        {
            return Shadow(
                color: shadowColor ?? UIColor.clear,
                offset: UIOffset(horizontal: shadowOffset.width, vertical: shadowOffset.height),
                opacity: shadowOpacity,
                radius: shadowRadius)
        }
    }
    
    /// 添加普通阴影 Opacity=0.4 Radius=4 Offset=(0,3) color=gray
    public func applyPlainShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 4
    }
    
    /// 添加立体阴影 
    public func applyCurvedShadow() {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        let depth = CGFloat(11.0)
        let lessDepth = 0.8 * depth
        let curvyness = CGFloat(5)
        let radius = CGFloat(1)
        
        let path = UIBezierPath()
        
        // top left
        path.move(to: CGPoint(x: radius, y: height))
        
        // top right
        path.addLine(to: CGPoint(x: width - 2*radius, y: height))
        
        // bottom right + a little extra
        path.addLine(to: CGPoint(x: width - 2*radius, y: height + depth))
        
        // path to bottom left via curve
        path.addCurve(to: CGPoint(x: radius, y: height + depth),
                             controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
                             controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness))
        
        let layer = self.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = radius
        layer.shadowOffset = CGSize(width: 0, height: -3)
    }
    
    /// 添加漂浮阴影
    public func applyHoverShadow() {
        let size = self.bounds.size
        let width = size.width
        let height = size.height
        
        let ovalRect = CGRect(x: 5, y: height + 5, width: width - 10, height: 15)
        let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
        
        let layer = self.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
