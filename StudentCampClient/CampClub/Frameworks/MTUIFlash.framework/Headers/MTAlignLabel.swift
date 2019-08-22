//  MTAlignLabel.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//
import UIKit

/// 对齐文本
public class MTAlignLabel: UILabel {

    
    /// 垂直对齐方式
    ///
    /// - top: 上
    /// - middle: 中
    /// - bottom: 下
    public enum VerticalAlignment : Int {
        
        /// vertical align top
        case top = 0
        /// vertical align moddle
        case middle = 1
        /// vertical align bottom
        case bottom = 2
    }
    
    /// 对齐方式 默认 verticalAlignmentTop
    public var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// init
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /// override textRect(forBounds: CGRect, limitedToNumberOfLines: Int) -> CGRect
    override public func textRect(forBounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect( forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        switch verticalAlignment {
        case .top:
            return CGRect(x: bounds.origin.x, y:  bounds.origin.y, width: rect.size.width, height: rect.size.height)
            
        case .middle:
            return CGRect(x: bounds.origin.x, y:  bounds.origin.y  + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            
        case .bottom:
             return CGRect(x: bounds.origin.x, y:  bounds.origin.y  + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            
        }
    }
    
    /// override drawText(in rect: CGRect)
    override public func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
    

}
