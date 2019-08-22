//
//  UINavigationBar+Adjustable.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.


import UIKit

private var navigationBarLayKey: String = "kMTNavigationBarOverLayerKey"

// MARK: - UINavigationBar 可调整
public extension UINavigationBar {
    
    // MARK: 上下滑动渐变
    
    /// 添加一个遮罩
    ///
    ///        override func viewWillAppear(animated: Bool) {
    ///            super.viewWillAppear(animated)
    ///            scrollViewDidScroll(tableView)
    ///            navigationController!.navigationBar.shadowImage = UIImage()
    ///            tableView.delegate = self  // if use tableview
    ///        }
    ///
    ///        override func viewWillDisappear(animated: Bool) {
    ///            super.viewWillDisappear(animated)
    ///            tableView.delegate = nil    // if use tableview
    ///            navigationController!.navigationBar.mt_reset()
    ///        }
    ///
    ///        func scrollViewDidScroll(scrollView: UIScrollView) {
    ///            let color = UIColor.orangeColor()
    ///            let offsetY = scrollView.contentOffset.y
    ///            if offsetY > 0.0 {
    ///                let alpha = 1 - ((0.0 + NAVBAR_CHANGE_POINT - offsetY) / NAVBAR_CHANGE_POINT)           //NAVBAR_CHANGE_POINT = 64
    ///                navigationController!.navigationBar.mt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
    ///            } else {
    ///                navigationController!.navigationBar.mt_setBackgroundColor(color.colorWithAlphaComponent(0))
    ///            }
    ///        }
    /// - Parameter backgroundColor: 颜色
    public func mt_setBackgroundColor(_ backgroundColor: UIColor) {
        if overlayer == nil {
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            let overlayer = UIView()
            //overlayer.frame = CGRect(x: 0, y: -20, width: UIScreen.main.bounds.size.width, height: self.bounds.height + 20)
            overlayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 20)
            overlayer.isUserInteractionEnabled = false
            overlayer.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,UIView.AutoresizingMask.flexibleHeight]
            //insertSubview(overlayer, at: 0)   //iOS 11.1 直接加不行，会出现在最上层。
            subviews.first?.insertSubview(overlayer, at: 0)
            
            self.overlayer = overlayer
        }
        self.overlayer!.backgroundColor = backgroundColor
    }
    
    /// 设置 Y 的偏移
    ///
    /// - Parameter translationY: 高度Y 偏移量
    public func mt_setTranslationY(_ translationY:CGFloat) {
        transform = CGAffineTransform(translationX: 0, y: translationY)
    }
    
    public func mt_setBackgroundLayerHeight(height: CGFloat) {
        let rect = overlayer?.frame
        overlayer?.frame = CGRect(x: 0, y: 0, width: (rect?.size.width)!, height: height)
    }
    
    /// 设置子元素 的透明度
    ///
    /// - Parameter alpha: 透明度
    public func mt_setElementsAlpha(_ alpha:CGFloat) {
        for (_, element) in subviews.enumerated() {
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type)
            {
                element.alpha = alpha
            }
            
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) {
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        items?.forEach({ (item) in
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
    
    /// 重置
    public func mt_reset() {
        setBackgroundImage(nil, for: .default)
        shadowImage = nil
        overlayer?.removeFromSuperview()
        overlayer = nil
    }
    
    fileprivate fileprivate(set) var overlayer: UIView? {
        get {
            return objc_getAssociatedObject(self, &navigationBarLayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &navigationBarLayKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

