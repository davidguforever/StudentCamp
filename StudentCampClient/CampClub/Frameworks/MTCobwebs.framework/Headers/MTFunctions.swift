//
//  MTFunctions.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit


/// 错误
///
/// - jsonSerialization: Json序列化错误
/// - errorLoadingSound: 声音加载错误
/// - pathNotExist: 地址不存在
/// - pathNotAllowed: 地址不允许
public enum MTKitError: Error {
    case jsonSerialization
    case errorLoadingSound
    case pathNotExist
    case pathNotAllowed
}

/// 一些有用功能的集合
public struct MT {
    
    //跳转到应用的AppStore页页面
    //  let url = "itms-apps://itunes.apple.com/app/id%@?action=write-review" + String(appITunesItemIdentifier)
    public static func gotoAppStore(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /// App Name
    public static var appDisplayName: String? {
        if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return bundleDisplayName
        } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            return bundleName
        }
        
        return nil
    }
    
    /// App 版本号 (CFBundleShortVersionString)
    public static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// App 内部版本号
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    /// App BundleID
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    /// App 版本号和内部版本号合并 (Returns both app's version and build numbers "v0.3(7)")
    public static var appVersionAndBuild: String? {
        if appVersion != nil && appBuild != nil {
            if appVersion == appBuild {
                return "v\(appVersion!)"
            } else {
                return "v\(appVersion!)(\(appBuild!))"
            }
        }
        return nil
    }
    
    /// 设备版本
    public static var deviceVersion: String {
        var size: Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }
    
    /// 是否Debug (Returns true if DEBUG mode is active //TODO: Add to readme)
    public static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    /// 是否Release (Returns true if RELEASE mode is active //TODO: Add to readme)
    public static var isRelease: Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }
    
    /// 是否模拟器 (Returns true if its simulator and not a device //TODO: Add to readme)
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
    
    /// 是否真机 (Returns true if its on a device and not a simulator //TODO: Add to readme)
    public static var isDevice: Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }
    
    /// 最上层ViewController
    public static var topMostVC: UIViewController? {
        let topVC = UIApplication.topViewController()
        if topVC == nil {
            print("Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return topVC
    }
    
    #if os(iOS)
    
    /// 当前屏幕方向 (Returns current screen orientation)
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    #endif
    
 
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat {
        
        #if os(iOS)
            
            if screenOrientation.isPortrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
            
        #elseif os(tvOS)
            
            return UIScreen.main.bounds.size.width
            
        #endif
    }
    
    /// 屏幕高度
    public static var screenHeight: CGFloat {
        
        #if os(iOS)
            
            if screenOrientation.isPortrait {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
            
        #elseif os(tvOS)
            
            return UIScreen.main.bounds.size.height
            
        #endif
    }
    
    #if os(iOS)
    
    /// 返回状态栏高度 StatusBar height
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /// Return screen's height without StatusBar
    public static var screenHeightWithoutStatusBar: CGFloat {
        if screenOrientation.isPortrait {
            return UIScreen.main.bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.main.bounds.size.width - screenStatusBarHeight
        }
    }
    
    #endif
    
    /// Returns the locale country code. An example value might be "ES". //TODO: Add to readme
    public static var currentRegion: String? {
        return (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    }

    
    /// 截屏通知调用 Calls action when a screen shot is taken
    ///
    /// - Parameter action: action
    public static func detectScreenShot(_ action: @escaping () -> ()) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            // executes after screenshot
            action()
        }
    }
    
    
    /// Iterates through enum elements, use with (for element in MT.iterateEnum(myEnum))
    public static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) { $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee } }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
    // MARK: - Dispatch
    
    /// Runs the function after x seconds
    public static func dispatchDelay(_ second: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    /// Runs function after x seconds
    public static func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    //TODO: Make this easier
    /// Runs function after x seconds with dispatch_queue, use this syntax: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
    /// Submits a block for asynchronous execution on the main queue
    public static func runThisInMainThread(_ block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    /// Runs in Default priority queue
    public static func runThisInBackground(_ block: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    /// Runs every second, to cancel use: timer.invalidate()
    public static func runThisEvery(seconds: TimeInterval, startAfterSeconds: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

}


public extension MT {
    
    //封装的日志输出功能（T表示不指定日志信息参数类型）
    public func log<T>(_ message:T, file:String = #file, function:String = #function,
               line:Int = #line) {
        #if DEBUG
            //获取文件名
            let fileName = (file as NSString).lastPathComponent
            //打印日志内容
            MT.print("\(fileName):\(line) \(function) | \(message)")
        #endif
    }
}


/// Extending the MT object with print functionality
public extension MT {
    // MARK: - 打印日志

    /// Enumeration of the log levels
    public enum logLevel: Int {
        // Informational loging, lowest level
        case info = 1
        // Debug loging, default level
        case debug = 2
        // Warning loging, You should take notice
        case warn = 3
        // Error loging, Something went wrong, take action
        case error = 4
        // Fatal loging, Something went seriously wrong, can't recover from it.
        case fatal = 5
        // Set the minimumLogLevel to .none to stop everything from loging
        case none = 6
        
   
        /// Get the emoticon for the log level.
        public func description() -> String {
            switch self {
            case .info:
                return "❓"
            case .debug:
                return "✳️"
            case .warn:
                return "⚠️"
            case .error:
                return "🚫"
            case .fatal:
                return "🆘"
            case .none:
                return ""
            }
        }
    }
    
    
    /// Set the minimum log level. By default set to .info which is the minimum. Everything will be loged.
    public static var minimumLogLevel: logLevel = .info
    

    /// The print command for writing to the output window
    public static func print<T>(_ object: T, _ level: logLevel = .debug, filename: String = #file, line: Int = #line, funcname: String = #function) {
        if level.rawValue >= MT.minimumLogLevel.rawValue {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
            let process = ProcessInfo.processInfo
            let threadId = "?"
            let file = URL(string: filename)?.lastPathComponent ?? ""
            Swift.print("\n\(level.description()) .\(level) ⏱ \(dateFormatter.string(from: Foundation.Date())) 📱 \(process.processName) [\(process.processIdentifier):\(threadId)] 📂 \(file)(\(line)) ⚙️ \(funcname) ➡️\r\t\(object)")
        }
    }
}


public extension MT {
    @available(*, deprecated, message: "TODO left in code")
    func TODO(_ log: String = "") {
        MT.print("⚠️ TODO code is still in use! ⚠️\n\(log)")
    }
    
    @available(*, deprecated, message: "TODO left in code")
    var TODO_: Never {
        fatalError("TODO left in code")
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
