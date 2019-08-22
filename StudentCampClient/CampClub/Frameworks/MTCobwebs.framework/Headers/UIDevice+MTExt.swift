//
//  UIDevice+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit
import Foundation

private let DeviceList = [
    /* iPod 5 */          "iPod5,1": "iPod Touch 5",
    /* iPod 6 */          "iPod7,1": "iPod Touch 6",
    /* iPhone 4 */        "iPhone3,1":  "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4",
    /* iPhone 4S */       "iPhone4,1": "iPhone 4S",
    /* iPhone 5 */        "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5",
    /* iPhone 5C */       "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C",
    /* iPhone 5S */       "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S",
    /* iPhone 6 */        "iPhone7,2": "iPhone 6",
    /* iPhone 6 Plus */   "iPhone7,1": "iPhone 6 Plus",
    /* iPhone 6S */       "iPhone8,1": "iPhone 6S",
    /* iPhone 6S Plus */  "iPhone8,2": "iPhone 6S Plus",
    /* iPhone SE */       "iPhone8,4": "iPhone SE",
    /* iPhone 7 */        "iPhone9,1": "iPhone 7",
    /* iPhone 7 Plus */   "iPhone9,2": "iPhone 7 Plus",
    /* iPhone 8 */        "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8",
    /* iPhone 8 Plus */   "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus",
    /* iPhone X */        "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X",
    /* iPhone XS */       "iPhone11,2": "iPhone XS",
    /* iPhone XS MAX*/    "iPhone11,4": "iPhone XS MAX", "iPhone11,6": "iPhone XS MAX", //"iPhone11,6": "iPhone XS MAX China"
    /* iPhone XR*/        "iPhone11,8": "iPhone XR",
                         
    /* iPad 2 */          "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2",
    /* iPad 3 */          "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3",
    /* iPad 4 */          "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4",
    /* iPad Air */        "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air",
    /* iPad Air 2 */      "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2",
    /* iPad Mini */       "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini",
    /* iPad Mini 2 */     "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2",
    /* iPad Mini 3 */     "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3",
    /* iPad Mini 4 */     "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4",
    /* iPad Pro */        "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro",
    /* AppleTV */         "AppleTV5,3": "AppleTV",
    /* Simulator */       "x86_64": "Simulator", "i386": "Simulator"
]


/// 设备尺寸
///
/// - unknownSize: 不知道的尺寸
/// - screen3_5Inch: 3.5
/// - screen4Inch: 4
/// - screen4_7Inch: 4.7
/// - screen5_5Inch: 5.5
/// - screen5_8Inch: 5.8
/// - screen6_1Inch: 6.1
/// - screen6_5Inch: 6.5
/// - screen7_9Inch: 7.9
/// - screen9_7Inch: 9.7
/// - screen12_9Inch: 12.9
public enum Size: Int {
    case unknownSize = 0
    case screen3_5Inch
    case screen4Inch
    case screen4_7Inch
    case screen5_5Inch
    case screen5_8Inch
    case screen6_1Inch
    case screen6_5Inch
    case screen7_9Inch
    case screen9_7Inch
    case screen12_9Inch
}


public extension UIDevice {
    
    /// 唯一标识符
    public static func idForVendor() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /// 操作系统名字  Operating system name
    public static func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    /// 操作系统版本 Operating system version
    public static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 操作系统版本号 Operating system version to Float
    public static func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }
    
    /// 设备名称
    public static func deviceName() -> String {
        return UIDevice.current.name
    }
    
    /// 设备语言
    public static func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    
    
    /// 设备型号
    ///
    /// - Returns: "iPhone 8" "iPhone 8 Plus" "iPhone X"
    public static func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }
    
    /// 唯一标识符
    public static func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }

    /// 是否是iPhone
    public static func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// 是否是iPad
    public static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    /// 设备型号
    public static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }

    /// 系统版本
    ///
    /// - eight: iOS8
    /// - nine: iOS9
    /// - ten: iOS10
    /// - eleven: iOS11
    /// - twelve: iOS12
    public enum Versions: Float {
        case eight = 8.0
        case nine = 9.0
        case ten = 10.0
        case eleven = 11.0
        case twelve = 12.0
    }
    
    /// 版本号判断
    public static func isVersion(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue && systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    /// 版本号判断
    public static func isVersionOrLater(_ version: Versions) -> Bool {
        return systemFloatVersion() >= version.rawValue
    }
    
    /// 版本号判断
    public static func isVersionOrEarlier(_ version: Versions) -> Bool {
        return systemFloatVersion() < (version.rawValue + 1.0)
    }
    
    /// 版本号判断
    public static var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }
    
    // MARK: iOS 8 Checks
    /// 版本号判断
    public static func IS_OS_8() -> Bool {
        return isVersion(.eight)
    }
    /// 版本号判断
    public static func IS_OS_8_OR_LATER() -> Bool {
        return isVersionOrLater(.eight)
    }
    /// 版本号判断
    public static func IS_OS_8_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eight)
    }
    
    // MARK: iOS 9 Checks
    /// 版本号判断
    public static func IS_OS_9() -> Bool {
        return isVersion(.nine)
    }
    /// 版本号判断
    public static func IS_OS_9_OR_LATER() -> Bool {
        return isVersionOrLater(.nine)
    }
    /// 版本号判断
    public static func IS_OS_9_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.nine)
    }
    
    // MARK: iOS 10 Checks
    /// 版本号判断
    public static func IS_OS_10() -> Bool {
        return isVersion(.ten)
    }
    /// 版本号判断
    public static func IS_OS_10_OR_LATER() -> Bool {
        return isVersionOrLater(.ten)
    }
    /// 版本号判断
    public static func IS_OS_10_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.ten)
    }
    // MARK: iOS 11 Checks
    /// 版本号判断
    public static func IS_OS_11() -> Bool {
        return isVersion(.eleven)
    }
    /// 版本号判断
    public static func IS_OS_11_OR_LATER() -> Bool {
        return isVersionOrLater(.eleven)
    }
    /// 版本号判断
    public static func IS_OS_11_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.eleven)
    }

    // MARK: iOS 12 Checks
    /// 版本号判断
    public static func IS_OS_12() -> Bool {
        return isVersion(.twelve)
    }
    /// 版本号判断
    public static func IS_OS_12_OR_LATER() -> Bool {
        return isVersionOrLater(.twelve)
    }
    /// 版本号判断
    public static func IS_OS_12_OR_EARLIER() -> Bool {
        return isVersionOrEarlier(.twelve)
    }
    
    /// 版本号比较
    public static func isSystemVersionOver(_ requiredVersion: String) -> Bool {
        switch systemVersion().compare(requiredVersion, options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            //println("iOS >= 8.0")
            return true
        case .orderedAscending:
            //println("iOS < 8.0")
            return false
        }
    }
    
    
    /// 获取设备尺寸
    ///
    /// - Returns: see `Size`
    public static func size() -> Size {
        let w: Double = Double(UIScreen.main.bounds.width)
        let h: Double = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
        case 480:
            return Size.screen3_5Inch
        case 568:
            return Size.screen4Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? Size.screen5_5Inch : Size.screen4_7Inch
        case 736:
            return Size.screen5_5Inch
        case 812:
            return Size.screen5_8Inch
        case 896:
            return UIScreen.main.scale == 3.0 ? Size.screen6_5Inch : Size.screen6_1Inch
        case 1024:
            if UIDevice.deviceModelReadable().contains("iPadMini") {
                return Size.screen7_9Inch
            } else {
                return Size.screen9_7Inch
            }
        case 1366:
            return Size.screen12_9Inch
        default:
            return Size.unknownSize
        }
    }
    
    
    /// 是否与另一尺寸相等
    ///
    /// - Parameter size: 尺寸
    /// - Returns: 结果
    public static func isEqualToScreenSize(_ size: Size) -> Bool {
        return size == UIDevice.size() ? true : false;
    }
    
    /// 是否大于另一尺寸
    ///
    /// - Parameter size: 尺寸
    /// - Returns: 结果
    public static func isLargerThanScreenSize(_ size: Size) -> Bool {
        return size.rawValue < UIDevice.size().rawValue ? true : false;
    }
    
    /// 是否小于另一尺寸
    ///
    /// - Parameter size: 尺寸
    /// - Returns: 结果
    public static func isSmallerThanScreenSize(_ size: Size) -> Bool {
        return size.rawValue > UIDevice.size().rawValue ? true : false;
    }

    
}
extension UIDevice {
    
    /// 是否 iPhone X
    static var isIphoneX: Bool {
        var modelIdentifier = ""
        if isSimulator {
            modelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        } else {
            var size = 0
            sysctlbyname("hw.machine", nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: size)
            sysctlbyname("hw.machine", &machine, &size, nil, 0)
            modelIdentifier = String(cString: machine)
        }
        
        return modelIdentifier == "iPhone10,3" || modelIdentifier == "iPhone10,6"
    }
    
    
    /// 是否模拟器
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
}


public extension UIDevice {
    /// the size of the file system(disk size)
    public static var diskSize: UInt64 {
        if let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()), let size = attr[FileAttributeKey.systemSize] as? UInt64 {
            return size
        }
        return 0
    }
    
    /// the amount of free space on the file system.
    public static var diskFreeSize: UInt64 {
        if let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()), let size = attr[FileAttributeKey.systemFreeSize] as? UInt64 {
            return size
        }
        return 0
    }
    
    /// the amount of space used
    public static var diskUsedSize: UInt64 {
        if let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()), let asize = attr[FileAttributeKey.systemSize] as? UInt64, let fsize = attr[FileAttributeKey.systemFreeSize] as? UInt64 {
            return asize - fsize
        }
        return 0
    }
    
    /// the file's filesystem file number
    public static var allFileNumber: UInt64 {
        if let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()), let size = attr[FileAttributeKey.systemFileNumber] as? UInt64 {
            return size
        }
        return 0
    }
}
