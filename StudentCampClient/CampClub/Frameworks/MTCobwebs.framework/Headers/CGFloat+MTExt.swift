//
//  CGFloat+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

// MARK: - Properties
public extension CGFloat {
    
    /// Absolute of CGFloat value.
    public var abs: CGFloat {
        return Swift.abs(self)
    }
    
    /// Ceil of CGFloat value.
    public var ceil: CGFloat {
        return Foundation.ceil(self)
    }
    
    /// Radian value of degree input.
    public var degreesToRadians: CGFloat {
        return CGFloat.pi * self / 180.0
    }
    
    /// Floor of CGFloat value.
    public var floor: CGFloat {
        return Foundation.floor(self)
    }
    
    /// Check if CGFloat is positive.
    public var isPositive: Bool {
        return self > 0
    }
    
    /// Check if CGFloat is negative.
    public var isNegative: Bool {
        return self < 0
    }
    
    /// Int.
    public var int: Int {
        return Int(self)
    }
    
    /// Float.
    public var float: Float {
        return Float(self)
    }
    
    /// Double.
    public var double: Double {
        return Double(self)
    }
    
    /// Degree value of radian input.
    public var radiansToDegrees: CGFloat {
        return self * 180 / CGFloat.pi
    }
    
}



/// 转换角度为弧度
///
/// - Parameter angle: 角度
/// - Returns:  弧度
public func degreesToRadians(_ angle: CGFloat) -> CGFloat {
	return (CGFloat(Double.pi) * angle) / 180.0
}



// MARK: - Methods
public extension CGFloat {
    
    /// Random CGFloat between two CGFloat values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random CGFloat between two CGFloat values.
    public static func randomBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        let delta = max - min
        return min + CGFloat(arc4random_uniform(UInt32(delta)))
    }
    
}
