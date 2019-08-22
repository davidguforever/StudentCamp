//
//  UIImageView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit

public extension UIApplication {
    /// Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
    /// 获取最上面的ViewController (Get the top most view controller from the base view controller; default param is UIWindow's rootViewController)
    public static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    
    /// 切换APP icon
    ///
    /// - Parameter name: 本地图片名字 ,在你的Info.plist中 CFBundle​Alternate​Icons
    ///
    ///          <key>CFBundleIcons</key>
    ///          <dict>
    ///            <key>CFBundleAlternateIcons</key>
    ///            <dict>
    ///                 <key>Green</key>
    ///                  <dict>
	///     			    <key>CFBundleIconFiles</key>
	///     			    <array>
    ///                        <string>Green</string>
	///     			    </array>
    ///                 </dict>
    ///             </dict>
    ///         </dict>
    public static func changeAppIcon(_ name: String?) {
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                UIApplication.shared.setAlternateIconName(name, completionHandler: { (Error) in
                    print(Error?.localizedDescription ?? "No Error")
                })
            }
        }
    }
}
