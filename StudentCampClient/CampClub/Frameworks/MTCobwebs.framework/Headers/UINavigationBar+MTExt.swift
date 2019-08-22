//
//  UINavigationBar+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UINavigationBar {

    /// 隐藏导航底部分割线
    public func hideBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = true
    }

    
    /// 显示导航底部分割线
    public func showBottomHairline() {
        let navigationBarImageView = hairlineImageViewInNavigationBar(self)
        navigationBarImageView?.isHidden = false
    }

    
    fileprivate func hairlineImageViewInNavigationBar(_ view: UIView) -> UIImageView? {
        if let view = view as? UIImageView, view.bounds.height <= 1.0 {
            return view
        }
        
        for subview in view.subviews {
            if let imageView = hairlineImageViewInNavigationBar(subview) {
                return imageView
            }
        }
        
        return nil
    }
    

    /// 修改 Navigation Bar 的背景颜色
    ///
    /// - Parameter color: 想要修改的颜色
    public static func barTintColor(_ color: UIColor) {
        UINavigationBar.appearance().barTintColor = color
    }
    
    
    /// 修改 Navigation Bar 的主题颜色
    ///
    /// - Parameter color: 想要修改的颜色
    public static func tintColor(_ color: UIColor) {
        UINavigationBar.appearance().tintColor = color
    }

    
    ///  修改 Navigation Bar 的文字颜色
    ///
    /// - Parameter color: 想要修改的颜色
    public static func titleTextColor(_ color: UIColor) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }

    /// 设置导航栏透明
    ///
    /// - Parameter transparent: 是否透明
    public func setTransparent(_ transparent: Bool) {
        if transparent {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            isTranslucent = true
            backgroundColor = .clear
        } else {
            // By default take values from UINavigationBar appearance
            let backImage = UINavigationBar.appearance().backgroundImage(for: .default)
            setBackgroundImage(backImage, for: .default)
            shadowImage = UINavigationBar.appearance().shadowImage
            isTranslucent = UINavigationBar.appearance().isTranslucent
            backgroundColor = UINavigationBar.appearance().backgroundColor
        }
    }
    
    /// Set Navigation Bar title, title color and font.
    ///
    /// - Parameters:
    ///   - font: title font
    ///   - color: title text color (default is .black).
    public func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        titleTextAttributes = attrs
    }
    
    /// Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTint tint: UIColor = .white) {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        setBackgroundImage(UIImage(), for: .default)
        tintColor = tint
        titleTextAttributes = [.foregroundColor: tint]
        shadowImage = UIImage()
    }
    
    /// Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    public func setColors(background: UIColor, text: UIColor) {
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: .default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }
}
