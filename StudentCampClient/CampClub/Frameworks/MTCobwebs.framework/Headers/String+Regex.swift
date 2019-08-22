//
//  String+Regex.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation

public extension String {

    /// 匹配正则表达式
    ///
    /// - Parameter regex: 正则表达式
    /// - Returns: true or false
	public func isValidateByRegex(_ regex: String) -> Bool {

		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluate(with: self)
	}


    
    /// 手机号码的有效性:分电信、联通、移动
    ///
    /// - Returns: true or false
	public func isMobileNumberClassification() -> Bool {

		/**
		 * 手机号码
		 * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
		 * 联通：130,131,132,152,155,156,185,186,1709
		 * 电信：133,1349,153,180,189,1700
		 */
         let MOBILE = "^1((3//d|5[0-35-9]|7[0-9]|8[025-9])//d)\\d{7}$"  //总况

        return isValidateByRegex(MOBILE)
	}

    /// 邮箱的有效性
	public func isEmailAddress() -> Bool {

		let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
		return self.isValidateByRegex(emailRegex)
	}
}

