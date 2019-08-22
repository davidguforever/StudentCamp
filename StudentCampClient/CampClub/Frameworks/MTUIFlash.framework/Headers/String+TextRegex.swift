//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


import Foundation


let moneyRegex = "^(?!0+(?:\\.0+)?$)(?:[1-9]\\d*|0)(?:\\.\\d{1,2})?$"
let telephoneRegex = "^1[3|4|5|6|7|8|9]\\d{9}$"
let bankcardRegex = "^\\d{16}|\\d{19}$"
let idRegex = "^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$"

/// 输入类型
public enum InputType {
    /// 金额
    case numberic
    /// 电话
    case telephone
    /// 银行卡
    case bankcard
    /// 身份证
    case identNumber
}

public extension String {
    
    /// 校验是否符合正则
    ///
    /// - Parameter type: 输入类型 see `InputType`
    /// - Returns: 结果 true or false
    public func checkRegex(_ type: InputType) -> Bool {
        switch type {
        case .numberic:
            if ( self =~ moneyRegex).boolValue {
                return true
            }
        
        case .telephone:
            if ( self =~ telephoneRegex).boolValue {
                return true
            }
        case .bankcard:
            if ( self =~ bankcardRegex).boolValue {
                return true
            }
        case .identNumber:
            if ( self =~ idRegex).boolValue {
                return true
            }
        }
        return false
    }
    
    
}
