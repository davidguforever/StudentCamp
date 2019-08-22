//
//  UIWebView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit
import Foundation
public extension UIWebView {
    
    /// Remove the background shadow of the UIWebView.
    public func removeBackgroundShadow() {
        for i in 0 ..< self.scrollView.subviews.count {
            let singleSubview: UIView = self.scrollView.subviews[i]
            if singleSubview.isKind(of: UIImageView.self) && singleSubview.frame.origin.x <= 500 {
                singleSubview.isHidden = true
                singleSubview.removeFromSuperview()
            }
        }
    }
    
    /// 加载 Load the requested website.
    ///
    /// - Parameter website: 必须是有效地址 Website to load.
    public func loadWebsite(_ website: String) {
        self.loadRequest(URLRequest(url: URL(string: website)!))
    }
}
