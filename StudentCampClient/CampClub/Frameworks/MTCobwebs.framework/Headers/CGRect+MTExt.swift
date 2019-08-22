//
//  CGRect+MTExt.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation




public extension CGRect {
    // MARK: - UIView Extends CGRect with helper properties for positioning and setting dimensions
    
    /// The top coordinate of the rect.
    public var top: CGFloat {
        get {
            return origin.y
        }
        set(value) {
            origin.y = value
        }
    }
    
    /// The left-side coordinate of the rect.
    public var left: CGFloat {
        get {
            return origin.x
        }
        set(value) {
            origin.x = value
        }
    }
    
    /// The bottom coordinate of the rect. Setting this will change origin.y of the rect according to
    /// the height of the rect.
    public var bottom: CGFloat {
        get {
            return origin.y + size.height
        }
        set(value) {
            origin.y = value - size.height
        }
    }
    
    /// The right-side coordinate of the rect. Setting this will change origin.x of the rect according to
    /// the width of the rect.
    public var right: CGFloat {
        get {
            return origin.x + size.width
        }
        set(value) {
            origin.x = value - size.width
        }
    }
    

    /// The center x coordinate of the rect.
    public var centerX: CGFloat {
        get {
            return origin.x + size.width / 2
        }
        set (value) {
            origin.x = value - size.width / 2
        }
    }
    
    /// The center y coordinate of the rect.
    public var centerY: CGFloat {
        get {
            return origin.y + size.height / 2
        }
        set (value) {
            origin.y = value - size.height / 2
        }
    }
    
    /// The center of the rect.
    public var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set (value) {
            centerX = value.x
            centerY = value.y
        }
    }
    
}

public extension CGRect {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    /// 初始化，由传入的字符串格式化
    ///
    /// - Parameter value:  字符串   格式："10,10,20,20" 或者 "{{10,10},{20,20}}"=> CGRectFromString()
    public init(stringLiteral value: StringLiteralType) {
        self.init()
        let rect: CGRect
        if value[value.startIndex] != "{" {
            let comp = value.components(separatedBy: ",")
            if comp.count == 4 {
                rect = NSCoder.cgRect(for: "{{\(comp[0]),\(comp[1])}, {\(comp[2]), \(comp[3])}}")
            } else {
                rect = CGRect.zero
            }
        } else {
            rect = NSCoder.cgRect(for: value)
        }
        
        self.size = rect.size
        self.origin = rect.origin
    }
    
    /// init `self.init(stringLiteral: value)`
    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(stringLiteral: value)
    }
    
    public typealias UnicodeScalarLiteralType = StringLiteralType
    
    /// init `self.init(stringLiteral: value)`
    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(stringLiteral: value)
    }
}
