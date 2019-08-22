//
//  Then.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation
import CoreGraphics

/// 初始化后的动作
public protocol Then {}

public extension Then where Self: Any {

    /// 初始化后把self传入Block ( Makes it available to set properties with closures just after initializing.)
    ///
    ///        let frame = CGRect().with {
    ///            $0.origin.x = 10
    ///            $0.size.width = 100
    ///        }
    ///
    /// - Parameter block: Self -> Void
    /// - Returns: Self
    public func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    /// Makes it available to execute something with closures.
    ///
    ///         UserDefaults.standard.do {
    ///           $0.set("bage", forKey: "username")
    ///           $0.set("springlo@126.com", forKey: "email")
    ///           $0.synchronize()
    ///         }
    public func `do`(_ block: (Self) -> Void) {
        block(self)
    }
}

public extension Then where Self: AnyObject {

    
    /// 初始化后把self传入Block ( Makes it available to set properties with closures just after initializing.)
    ///
    ///        let label = UILabel().then {
    ///            $0.textAlignment = .Center
    ///            $0.textColor = UIColor.blackColor()
    ///            $0.text = "Hello, World!"
    ///        }
    ///
    ///        ///当自定义类型时:
    ///
    ///        extension MyType: Then {}
    ///
    ///        let instance = MyType().then {
    ///            $0.title = "Fuck!"
    ///        }
    ///
    /// - Parameter block: Self -> Void
    /// - Returns: Self
    public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
    
}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}

