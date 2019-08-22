//
//  NSObect+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension NSObject {
    /// 对象类型
	public var className: String {
		return type(of: self).className
	}
    /// 对象类型
	public static var className: String {
		return stringFrom(self)
	}

}


/// 获取指定对象的类型名称
public func stringFrom(_ aClass: AnyClass) -> String {
	return NSStringFromClass(aClass).components(separatedBy: ".").last!
}
