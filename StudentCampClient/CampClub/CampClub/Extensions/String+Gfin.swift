//
//  String+Gfin.swift
//  Gfintech
//
//  Created by Luochun on 2017/7/11.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    static func random(length: Int = 1) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0 ..< length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            let index = base.index(base.startIndex, offsetBy: Int(randomValue))
            
            randomString += "\(base[index])"
        }
        
        return randomString
    }
}

extension String {
    var decimalFormatter: String {
        if let decimal = Double(self) {
            let number = NSNumber(value: decimal)
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            guard let string = formatter.string(from: number) else {
                return self
            }
            return string
        }
        return self
    }
    
    /// 以分为整数的字符串转为金额小数，20000000 -> 20,000.00
    func convertMoneyFormat() -> String {
        if let decimal = Double(self) {
            let number = NSNumber(value: decimal / 100 )
            return number.convertAmount()
        }
        return self
        
    }
    
    /// 200000 -> 20,000
    func convertAmount() -> String {
        if let decimal = Double(self) {
            let number = NSNumber(value: decimal)
            return number.convertAmount()
        }
        return self
        
    }
    
    /// 转为万单位
    func convertAmountWunit() -> String {
        if let decimal = Double(self) {
            let number = NSNumber(value: decimal)
            return number.convertAmountWunit()
        }
        return self
        
    }
    
    /// 转为万,智能小数，最多3位
    func smartWunit() -> String {
        if let decimal = Double(self) {
            let number = NSNumber(value: decimal)
            return number.smartWunit()
        }
        return self
    }
    
    /// 金额 取整
    func floor() -> String {
        if let decimal = Float(self) {
            if fmodf(decimal, 1) == 0 {//如果有一位小数点
                return String(format: "%.0f", decimal)
            } else if fmodf(decimal * 10, 1) == 0 {//如果有两位小数点
                return String(format: "%.1f", decimal)
            } else {
                return String(format: "%.2f", decimal)
            }
            //return String(Int(Darwin.floor(decimal)))
        }
        return self
    }
    

}

extension NSNumber {
    /// 200000 -> 20,000
    func convertAmount() -> String {
        let amount = self.doubleValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let string = formatter.string(from: NSNumber(value: amount)) else {
            return ""
        }
        return string
    }
    
    /// 转为万
    func convertAmountWunit() -> String {
        let amount = self.doubleValue / 10_000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.positiveFormat = "###,##0.000"
        guard let string = formatter.string(from: NSNumber(value: amount)) else {
            return ""
        }
        return string
    }
    
    /// 转为万,智能小数，最多3位
    func smartWunit() -> String {
        let amount = self.doubleValue / 10_000
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let intVal = Int(self.doubleValue)
        if intVal % 10_000 == 0 {
            formatter.positiveFormat = "###,##0"
        } else if intVal % 1000 == 0 {
            formatter.positiveFormat = "###,##0.0"
        }  else if intVal % 100 == 0 {
            formatter.positiveFormat = "###,##0.00"
        } else {
            formatter.positiveFormat = "###,##0.000"
        }
        guard let string = formatter.string(from: NSNumber(value: amount)) else {
            return ""
        }
        return string
    }
}


public extension String {
    
    /// 匹配正则表达式
    ///
    /// - Parameter regex: 正则表达式
    /// - Returns: true or false
    func isValidateByRegex(_ regex: String) -> Bool {
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    
    
    /// 手机号码的有效性:分电信、联通、移动
    ///
    /// - Returns: true or false
    func isMobileNumberClassification() -> Bool {
        
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
    func isEmailAddress() -> Bool {
        
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return self.isValidateByRegex(emailRegex)
    }
    
    
    
}


extension String {
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func widthWithFont(font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        guard self.count > 0 else {
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let rect = self.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
}
