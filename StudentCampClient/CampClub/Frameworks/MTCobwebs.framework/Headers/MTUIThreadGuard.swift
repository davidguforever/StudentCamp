//
//  MTUIThreadGuard.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit
//
///// It is better to use a debug flag here for not add this extension to Release build. (You don't want user see App crash)
//#if debug
//    private let swizzle: (String, String, UIView.Type) -> Void = { (originalMethod, swizzledMethod, view) in
//        let originalSelector = Selector(originalMethod)
//        let swizzledSelector = Selector(swizzledMethod)
//
//        let originalMethod = class_getInstanceMethod(view, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(view, swizzledSelector)
//
//        let didAddMethod = class_addMethod(view, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
//
//        if didAddMethod {
//            class_replaceMethod(view, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod)
//        }
//    }
//
//    // MARK: - A extension of UIView, basic idea is use runtime to exchange setNeedsLayout, setNeedsDisplay and setNeedsDisplayInRect with our customized method, and do the checking process in that method
//    public extension UIView {
//        /// 检查UI更新是否在主线程里   swizzle setNeedsLayout to guardSetNeedsLayout
//        override static func initialize() {
//            //If self is the subclass of UIView, return
//            if self !== UIView.self {
//                return
//            }
//
//            let methods = [
//                "setNeedsLayout": "guardSetNeedsLayout",
//                "setNeedsDisplay": "guardSetNeedsDisplay",
//                "setNeedsDisplayInRect:": "guardSetNeedsDisplayInRect:"
//            ]
//
//            methods.forEach {(key, value) in
//                swizzle(key, value, self)
//            }
//        }
//
//        private func guardSetNeedsLayout() {
//            checkThread()
//            guardSetNeedsLayout()
//        }
//
//        private func guardSetNeedsDisplay() {
//            checkThread()
//            guardSetNeedsDisplay()
//        }
//
//        private func guardSetNeedsDisplayInRect(_ rect: CGRect) {
//            checkThread()
//            guardSetNeedsDisplayInRect(rect)
//        }
//        //If not on main thread, assert the app. From the left side thread stack view, you can easily find which line has problem
//        private func checkThread() {
//            assert(Thread.isMainThread, "❎ You changed UI element not on main thread")
//        }
//
//    }
//#endif

