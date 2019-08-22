//  MTAlert.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation
import UIKit

/// Simple UIAlertController builder class
public class MTAlert {
    fileprivate var alertController: UIAlertController
    
    public init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style) {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    /// 文本
    public func setTitle(_ title: String) -> Self {
        alertController.title = title
        return self
    }
    /// 信息
    public func setMessage(_ message: String) -> Self {
        alertController.message = message
        return self
    }
    
    /// 设置动画跳转属性
    public func setPopoverPresentationProperties(sourceView: UIView? = nil, sourceRect:CGRect? = nil, barButtonItem: UIBarButtonItem? = nil, permittedArrowDirections: UIPopoverArrowDirection? = nil) -> Self {
        
        if let poc = alertController.popoverPresentationController {
            if let view = sourceView {
                poc.sourceView = view
            }
            if let rect = sourceRect {
                poc.sourceRect = rect
            }
            if let item = barButtonItem {
                poc.barButtonItem = item
            }
            if let directions = permittedArrowDirections {
                poc.permittedArrowDirections = directions
            }
        }
        
        return self
    }
    
    /// 添加按钮事件
    public func addAction(title: String = "", style: UIAlertAction.Style = .default, handler: @escaping ((UIAlertAction?) -> ()) = { _ in }) -> Self {
        alertController.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    /// 添加文本输入框事件
    public func addTextFieldHandler(_ handler: @escaping ((UITextField?) -> ()) = { _ in }) -> Self {
        alertController.addTextField(configurationHandler: handler)
        return self
    }
}

public extension MTAlert {

    
    /// 显示弹出框
    ///
    ///            MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .alert)
    ///                .addAction(title: "NO", style: .cancel) { _ in }
    ///                .addAction(title: "YES", style: .default) { _ in }
    ///                .show(animated: true)
    ///
    ///            // ActionSheet Sample
    ///            if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
    ///            // Sample to show on iPad
    ///                MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
    ///                    .addAction(title: "NO", style: .cancel) { _ in }
    ///                    .addAction(title: "YES", style: .default) { _ in }
    ///                    .show(animated: true)
    ///            } else {
    ///            /*
    ///             Sample to show on iPad With setPopoverPresentationProperties(), specify the properties of UIPopoverPresentationController.
    ///             */
    ///                MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
    ///                    .addAction(title: "YES", style: .default) { _ in }
    ///                    .addAction(title: "Not Sure", style: .default) { _ in }
    ///                    .setPopoverPresentationProperties(sourceView: view, sourceRect: CGRectMake(0, 0, 100, 100), barButtonItem: nil,  permittedArrowDirections: .Any)
    ///               .show(animated: true)
    ///             }
    ///
    /// - Parameters:
    ///   - animated:  动画
    ///   - completionHandler: 完成后回调事件
    public func show(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self.alertController, animated: animated, completion: completionHandler)
    }
}
