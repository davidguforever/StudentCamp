//
//  DispatchQueue+MTExt.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation


public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    
    /// 运行一次
    ///
    /// - Parameters:
    ///   - file: 文件
    ///   - function: 函数
    ///   - line: 行
    ///   - block: 运行事件
    public static func once(file: String = #file, function: String = #function, line: Int = #line, block:(()->()) ) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    

    /// Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
    ///    only execute the code once even in the presence of multithreaded calls.
    ///
    /// - Parameters:
    ///   - token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
    ///   - block: Block to execute once
    public static func once(token: String, block:(()->()) ) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
