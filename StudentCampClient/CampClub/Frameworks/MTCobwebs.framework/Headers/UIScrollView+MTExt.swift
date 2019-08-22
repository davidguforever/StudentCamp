//
//  UIScrollView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UIScrollView {
    
    /// 是否在顶端
    public var isAtTop: Bool {
        
        return contentOffset.y == -contentInset.top
    }

    /// 滚动到顶端
    public func scrollsToTop() {
        
        let topPoint = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topPoint, animated: true)
    }
}

