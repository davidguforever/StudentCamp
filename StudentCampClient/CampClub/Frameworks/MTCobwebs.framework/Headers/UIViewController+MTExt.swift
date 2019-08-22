//  UIViewController+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit
import SafariServices

public extension UIViewController {

	// MARK: - Notifications
	
	fileprivate func addNotificationObserver(_ name: String, selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
	}

	fileprivate func removeNotificationObserver(_ name: String) {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: name), object: nil)
	}
    
    
    /// 移除当前ViewController所有的监听
	public func removeNotificationObserver() {
		NotificationCenter.default.removeObserver(self)
	}
    
    /// 添加通知 UIKeyboardWillShowNotification
	public func addKeyboardWillShowNotification() {
		self.addNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue, selector: #selector(UIViewController.keyboardWillShowNotification(_:)))
	}
    
    /// 添加通知 UIKeyboardDidShowNotification
	public func addKeyboardDidShowNotification() {
		self.addNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue, selector: #selector(UIViewController.keyboardDidShowNotification(_:)))
	}
    
    /// 添加通知 UIKeyboardWillHideNotification
	public func addKeyboardWillHideNotification() {
		self.addNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue, selector: #selector(UIViewController.keyboardWillHideNotification(_:)))
	}
    
    
    /// 添加通知 UIKeyboardDidHideNotification
	public func addKeyboardDidHideNotification() {
		self.addNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue, selector: #selector(UIViewController.keyboardDidHideNotification(_:)))
	}
    

    /// 移除通知 UIKeyboardWillShowNotification
	public func removeKeyboardWillShowNotification() {
		self.removeNotificationObserver(UIResponder.keyboardWillShowNotification.rawValue)
	}

    /// 移除通知 UIKeyboardDidShowNotification
	public func removeKeyboardDidShowNotification() {
		self.removeNotificationObserver(UIResponder.keyboardDidShowNotification.rawValue)
	}

    /// 移除通知 UIKeyboardWillHideNotification
	public func removeKeyboardWillHideNotification() {
		self.removeNotificationObserver(UIResponder.keyboardWillHideNotification.rawValue)
	}
    
    /// 移除通知 UIKeyboardDidHideNotification
	public func removeKeyboardDidHideNotification() {
		self.removeNotificationObserver(UIResponder.keyboardDidHideNotification.rawValue)
	}

    
    @objc fileprivate func keyboardDidShowNotification(_ notification: Notification) {
		let nInfo = notification.userInfo as! [String: NSValue]
		let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey]
		let frame = value?.cgRectValue

		keyboardDidShowWithFrame(frame!)
	}

    @objc fileprivate func keyboardWillShowNotification(_ notification: Notification) {
		let nInfo = notification.userInfo as! [String: NSValue]
		let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey]
		let frame = value?.cgRectValue

		keyboardWillShowWithFrame(frame!)
	}

    @objc fileprivate func keyboardWillHideNotification(_ notification: Notification) {
		let nInfo = notification.userInfo as! [String: NSValue]
		let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey]
		let frame = value?.cgRectValue

		keyboardWillHideWithFrame(frame!)
	}

    @objc fileprivate func keyboardDidHideNotification(_ notification: Notification) {
		let nInfo = notification.userInfo as! [String: NSValue]
		let value = nInfo[UIResponder.keyboardFrameEndUserInfoKey]
		let frame = value?.cgRectValue

		keyboardDidHideWithFrame(frame!)
	}

    // MARK: - Keyboard Notification

    /// 键盘即将显示  供子类重写
    ///
    /// - Parameter frame: 当前键盘位置
	public func keyboardWillShowWithFrame(_ frame: CGRect) {

	}

    
    /// 键盘已经显示  供子类重写
    ///
    /// - Parameter frame: 当前键盘位置
	public func keyboardDidShowWithFrame(_ frame: CGRect) {

	}

    /// 键盘即将隐藏  供子类重写
    ///
    /// - Parameter frame:  当前键盘位置
	public func keyboardWillHideWithFrame(_ frame: CGRect) {

	}
    
    ///  键盘已经隐藏  供子类重写
    ///
    /// - Parameter frame:  当前键盘位置
	public func keyboardDidHideWithFrame(_ frame: CGRect) {

	}

	// MARK: - VC Container
	/// get Top
	public var top: CGFloat {
		get {
			if let me = self as? UINavigationController {
				return me.visibleViewController!.top
			}
			if let nav = self.navigationController {
				if nav.isNavigationBarHidden {
					return view.minY
				} else {
					return nav.navigationBar.maxY
				}
			} else {
				return view.y
			}
		}
	}
	/// get Bottom
	public var bottom: CGFloat {
		get {
			if let me = self as? UINavigationController {
				return me.visibleViewController!.bottom
			}
			if let tab = tabBarController {
				if tab.tabBar.isHidden {
					return view.maxY
				} else {
					return tab.tabBar.y
				}
			} else {
				return view.maxY
			}
		}
	}
	/// get Tab bar height
	public var tabBarHeight: CGFloat {
		get {
			if let me = self as? UINavigationController {
				return me.visibleViewController!.tabBarHeight
			}
			if let tab = self.tabBarController {
				return tab.tabBar.frame.size.height
			}
			return 0
		}
	}
	/// 获取导航栏高度
	public var navigationBarHeight: CGFloat {
		get {
			if let me = self as? UINavigationController {
				return me.visibleViewController!.navigationBarHeight
			}
			if let nav = self.navigationController {
				return nav.navigationBar.height
			}
			return 0
		}
	}
	/// 获取导航栏颜色
	public var navigationBarColor: UIColor? {
		get {
			if let me = self as? UINavigationController {
				return me.visibleViewController!.navigationBarColor
			}
			return navigationController?.navigationBar.tintColor
		} set(value) {
			navigationController?.navigationBar.barTintColor = value
		}
	}
	/// 获取导航栏
	public var navBar: UINavigationBar? {
		get {
			return navigationController?.navigationBar
		}
	}
	/// 获取Application Frame
	public var applicationFrame: CGRect {
		get {
			return CGRect(x: view.x, y: top, width: view.width, height: bottom - top)
		}
	}

	// MARK: - VC Flow
    
    /// Push ViewController with animation
    ///
    /// - Parameter vc: viewcontroller
	public func pushVC(_ vc: UIViewController) {
		navigationController?.pushViewController(vc, animated: true)
	}

    
    /// Pop ViewController with animation
	public func popVC() {
		let _ = navigationController?.popViewController(animated: true)
	}
    
    /// Pop to Root ViewController with animation
    public func popToRootVC() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    /// Present ViewController with animation
    ///
    /// - Parameter vc: viewcontroller
	public func presentVC(_ vc: UIViewController) {
		present(vc, animated: true, completion: nil)
	}

    
    /// Dismiss ViewController with animation
    ///
    /// - Parameter completion: 完成后的事件
	public func dismissVC(completion: (() -> Void)?) {
		dismiss(animated: true, completion: completion)
	}


    /// 添加子界面到指定界面
    ///
    /// - Parameters:
    ///   - vc: 子界面所属ViewController
    ///   - toView: 指定界面
	public func addAsChildViewController(_ vc: UIViewController, toView: UIView) {
		toView.addSubview(vc.view)
		self.addChild(vc)
		vc.didMove(toParent: self)
	}

	/// Adds image named: as a UIImageView in the Background
	public func setBackgroundImage(_ named: String) {
		let image = UIImage(named: named)
		let imageView = UIImageView(frame: view.frame)
		imageView.image = image
		view.addSubview(imageView)
		view.sendSubviewToBack(imageView)
	}

	/// Adds UIImage as a UIImageView in the Background
	@nonobjc public func setBackgroundImage(_ image: UIImage) {
		let imageView = UIImageView(frame: view.frame)
		imageView.image = image
		view.addSubview(imageView)
		view.sendSubviewToBack(imageView)
	}

}

public extension UIViewController {
    /// 获取Navigation Push Stack上一个ViewControlller
    public var previousViewController: UIViewController? {
        if let controllersOnNavStack = self.navigationController?.viewControllers {
            let n = controllersOnNavStack.count
            //if self is still on Navigation stack
            if controllersOnNavStack.last === self, n > 1 {
                return controllersOnNavStack[n - 2]
            } else if n > 0 {
                return controllersOnNavStack[n - 1]
            }
        }
        return nil
    }
}

public extension UIViewController {
    
	/// 状态栏高度
	var statusBarHeight: CGFloat {

		if let window = view.window {
			let statusBarFrame = window.convert(UIApplication.shared.statusBarFrame, to: view)
			return statusBarFrame.height

		} else {
			return 0
		}
	}
	/// 顶栏高度   状态栏+导航栏
	var topBarsHeight: CGFloat {
		return statusBarHeight + navigationBarHeight
	}
}

// MAKR: - openURL

public extension UIViewController {
    // MARK: - Open SFSafariViewController
    /// present SFSafariViewController 打开URL
	func openURL(_ URL: Foundation.URL) {

		if #available(iOS 9.0, *) {

			let safariViewController = SFSafariViewController(url: URL)
			present(safariViewController, animated: true, completion: nil)

		} else {
			UIApplication.shared.openURL(URL)
		}
	}
}

