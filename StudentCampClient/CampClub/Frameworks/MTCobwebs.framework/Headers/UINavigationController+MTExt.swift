//  UINavigationController+MTExt.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    
    // MARK: - Methods
    public extension UINavigationController {
        
        /// Pop ViewController with completion handler.
        ///
        /// - Parameter completion: optional completion handler (default is nil).
        public func popViewController(_ completion: (() -> Void)? = nil) {
            // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            popViewController(animated: true)
            CATransaction.commit()
        }
        
        /// Push ViewController with completion handler.
        ///
        /// - Parameters:
        ///   - viewController: viewController to push.
        ///   - completion: optional completion handler (default is nil).
        public func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
            // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            pushViewController(viewController, animated: true)
            CATransaction.commit()
        }
        
        /// Make navigation controller's navigation bar transparent.
        ///
        /// - Parameter tint: tint color (default is .white).
        public func makeTransparent(withTint tint: UIColor = .white) {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.tintColor = tint
            navigationBar.titleTextAttributes = [.foregroundColor: tint]
        }
        
    }

    // MARK: - Methods
    public extension UINavigationController {
        
        /// 移除指定界面
        ///
        /// - Parameter item: viewcontroller
        public func remove(_ item: UIViewController) {
            var vcs = viewControllers
            vcs.remove(item)
            viewControllers = vcs
        }
        /// 移除指定多个界面
        ///
        /// - Parameter item: viewcontroller
        public func remove(_ items: [UIViewController]) {
            var vcs = self.viewControllers
            items.forEach({
                vcs.remove($0)
            })
            
            self.viewControllers = vcs
        }
        /// 移除指定位置界面
        ///
        /// - Parameter item: viewcontroller
        public func remove(_ index: Int) {
            var vcs = viewControllers
            if vcs.count > index && index > -1 {
                vcs.remove(at: index)
            }
            viewControllers = vcs
        }
    }
#endif
