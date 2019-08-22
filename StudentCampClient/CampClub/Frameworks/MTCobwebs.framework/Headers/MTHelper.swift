//
//  MTHelper.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation
import UIKit

/// 取消任务Block
public typealias CancelableTask = (_ cancel: Bool) -> ()


/// 延迟执行事件
///
/// - Parameters:
///   - time: 延迟时间
///   - work: 执行事件
/// - Returns: 取消 see `CancelableTask`
@discardableResult
public func delay(_ time: TimeInterval, work: @escaping ()->()) -> CancelableTask? {

	var finalTask: CancelableTask?

	let cancelableTask: CancelableTask = { cancel in
		if cancel {
			finalTask = nil // key
		} else {
			DispatchQueue.main.async(execute: work)
		}
	}

	finalTask = cancelableTask

	DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
		if let task = finalTask {
			task(false)
		}
	}

	return finalTask
}


/// 取消执行
public func cancel(_ cancelableTask: CancelableTask?) {
	cancelableTask?(true)
}

/// 找到当前聚焦响应
///
/// - Returns: UIResponder?
public func findFirstResponder() -> UIResponder? {
    var firstResponder: UIResponder? = nil
    if let window = UIApplication.shared.delegate?.window, let view = window {
        firstResponder = findFirstResponderInView(view)
    }
    return firstResponder
}

/// 找到提供界面的聚焦响应
///
/// - Parameter view: UIView
/// - Returns: UIResponder?
public func findFirstResponderInView(_ view: UIView) -> UIResponder? {
    var firstResponder: UIResponder? = nil
    if view.isFirstResponder {
        firstResponder = view
    } else {
        for subview in view.subviews {
            if subview.isFirstResponder {
                firstResponder = subview
                break
            } else {
                firstResponder = findFirstResponderInView(subview)
                if firstResponder != nil { break }
            }
        }
    }
    return firstResponder
}


//https://medium.com/swift-snippets/swift-snippet-11-rawrepresentable-2c5ed62f868c#.guri8a2nz
public extension RawRepresentable where RawValue == Int {
    
    /// 获取 `RawRepresentable` 的数量  如：Enum<Int>
    public static var itemsCount: Int {
        var index = 0
        while Self(rawValue: index) != nil { index += 1 }
        return index
    }
    
    /// 获取枚举所有值的数组
    public static var items: [Self] {
        var items: [Self] = []
        var index = 0
        while let item = Self(rawValue: index) {
            items.append(item)
            index += 1
        }
        return items
    }
}

