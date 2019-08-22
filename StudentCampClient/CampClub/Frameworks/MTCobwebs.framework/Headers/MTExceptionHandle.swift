//
//  MTExceptionHandle.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation



public func exceptionHandler(exception: NSException) {
    /// 堆栈信息
    let callStackSymbols: Array = exception.callStackSymbols as Array
    
    /// 错误原因
    let reason: String = exception.reason!
    
    /// 错误标识
    let name = exception.name.rawValue
    
    let format = "========异常错误报告========\n错误标识:%@\n错误原因:\n%@\n堆栈信息:\n%@"
    let info = String(format: format, name, reason, callStackSymbols)
    
    print(info)
    
    
    var errorLog: [String: Any] = [:]
    errorLog[MTException.name] = name
    errorLog[MTException.reason] = reason
    errorLog[MTException.userInfo] = exception.userInfo as Any?
    errorLog[MTException.callStackSymbols] = callStackSymbols
    let date = Date().toString("YYYYMMddhhmmss")
    errorLog["date"] = date
    
    let dic = errorLog as Dictionary
    
    do {
        
        
        let errorData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        
        
        let path = MTException.filePath + "/" + date + ".log"
        
        //let data = NSKeyedArchiver.archivedData(withRootObject: dic)
        
        if ((try? errorData.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil) == true {
            print("崩溃日志保存成功")
        } else {
            print("崩溃日志保存失败")
        }

    } catch {
        print(error.localizedDescription)
    }
    
}

func handleSignal(signal: Int32) {

    switch signal {
    default: break
    }
}

/// 闪退日志处理
///
///      MTException.enableException()
///
public struct MTException {

	static let name = "name"
	static let reason = "reason"
	static let userInfo = "useInfo"
	static let callStackSymbols = "callStackSymbols"

    /// 日志路径  URL:`/Documents/crash/.Exception`
	public static var filePath: String {
        
		let _path = NSHomeDirectory() + "/Documents/crash/.Exception"
		if FileManager.default.fileExists(atPath: _path) == false {
			do {
				try FileManager.default.createDirectory(atPath: _path, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print("\(error)")
			}
		}

		return _path
	}

    /// 初始化
	public init() {
		print("exception path : \(MTException.filePath)")
	}

    
    /// 开启异常监听
	public static func enableException() {

		let handle = NSGetUncaughtExceptionHandler()
		if handle != nil {
			print("外部检查到 有捕获 Excption 操作，拦截了")
		}
        NSSetUncaughtExceptionHandler(exceptionHandler)
		
	}
    
    static func register() {
        NSSetUncaughtExceptionHandler(exceptionHandler)
        signal(SIGILL, handleSignal)
        signal(SIGABRT, handleSignal)
        signal(SIGFPE, handleSignal)
        signal(SIGBUS, handleSignal)
        signal(SIGSEGV, handleSignal)
        signal(SIGSYS, handleSignal)
        signal(SIGPIPE, handleSignal)
        signal(SIGTRAP, handleSignal)
    }
    
    static func unregister() {
        NSSetUncaughtExceptionHandler(nil)
        signal(SIGILL, SIG_DFL)
        signal(SIGABRT, SIG_DFL)
        signal(SIGFPE, SIG_DFL)
        signal(SIGBUS, SIG_DFL)
        signal(SIGSEGV, SIG_DFL)
        signal(SIGSYS, SIG_DFL)
        signal(SIGPIPE, SIG_DFL)
        signal(SIGTRAP, SIG_DFL)
    }
    
    ///  获取日志信息
	public static func getCrashLog() -> String? {
		let dirEnum = FileManager.default.enumerator(atPath: MTException.filePath)
		while let name = dirEnum?.nextObject() {
            
            let path = MTException.filePath.appendingPathComponent(name as! String)
            do {
                let error = try String(contentsOfFile: path, encoding: .utf8)
                return error
            }
            catch {return nil}
            
			
		}
		return nil
    }
    
    /// 移除日志文件
    @discardableResult
	public static func removeCrashLog() -> Bool {
		let dirEnum = FileManager.default.enumerator(atPath: MTException.filePath)
		while let name = dirEnum?.nextObject() {
			let fullPath = MTException.filePath.appendingPathComponent(name as! String)
			if FileManager.default.fileExists(atPath: fullPath) {

				do {
					try FileManager.default.removeItem(atPath: fullPath)
				} catch {
					return false
				}
			}
		}

		return true
	}
    
}
