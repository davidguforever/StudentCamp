//
//  FileManager+MTExt.swift
// 
//  Copyright © 2017年 Maintis. All rights reserved.
//

import Foundation


public extension FileManager {
    
    /// Get document dir
    public static var documentsDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths.first
        return documentsDirectory!
    }
    

    /// 获取指定路径下文件大小，注意是文件
    ///
    /// - Parameter filePath: 文件路径
    /// - Returns: 文件大小 单位:M
    public static func fileSizeAtPath(_ filePath: String) -> Float {
        let manager = FileManager.default
        var fileSize:Float = 0.0
        if manager.fileExists(atPath: filePath) {
            do {
                let attr: NSDictionary = try manager.attributesOfItem(atPath: filePath) as NSDictionary
                fileSize = Float(attr.fileSize())
                
            } catch {
            }
        }
        return fileSize
    }
    
    
    /// 遍历文件夹获取目录下的所有的文件 遍历计算大小
    ///
    /// - Parameter folderPath: document 下的路径
    /// - Returns: 文件大小 单位:M
    public static func folderSizeAtPath(_ folderPath: String) -> Float {
        if folderPath.count == 0 {
            return 0
        }
        let manager = FileManager.default
        if !manager.fileExists(atPath: folderPath) {
            return 0
        }
        var fileSize:Float = 0.0
        do {
            let files = try manager.contentsOfDirectory(atPath: folderPath)
            for file in files {
                let path = self.documentsDirectory + "/\(file)"
                fileSize = fileSize + fileSizeAtPath( path)
            }
        }   catch {
        }
        print("\(fileSize)")
        return fileSize/(1024.0*1024.0)
    }

    
    /// 获取磁盘总空间大小
    ///
    /// - Returns: 磁盘总空间大小 单位:GB
    public static func diskOfAllSizeMBytes() -> CGFloat {
        var size: CGFloat = 0.0
        do {
            let dic: Dictionary = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            
            let number = dic[.systemFreeSize] as? NSNumber
            size = (number as! CGFloat) / 1024 / 1024 / 1024
        }catch {
            print("error: \(error)")
        }
        return size
    }
    
    /// 获取磁盘可用空间
    ///
    /// - Returns: 磁盘可用空间大小 单位:GB
    public static func diskOfFreeSizeMBytes() -> CGFloat {
        var size: CGFloat = 0.0
        do {
            let dic:Dictionary = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let number = dic[.systemFreeSize] as? NSNumber
            size = (number as! CGFloat) / 1024 / 1024 / 1024
        }catch {
            print("error: \(error)")
        }
        return size
    }
    
}


public extension FileManager {
    
    ///  返回指定路径单个文件的大小
    public func getFileSizeWithPath(_ path: String) -> CGFloat {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            
            do {
                let size = try (fileManager.attributesOfItem(atPath: path)) as NSDictionary
                let value = size.value(forKey: "NSFileSize") as! CGFloat
                return value/1024.0/1024.0
            } catch { }
        }
        return 0
    }
    
    ///  返回指定路径文件夹的大小
    public func getFolderSizeWithPath( path: String) -> CGFloat {
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path as String) {
            var folderSize : CGFloat = 0.0
            
            let childerFiles = fileManager.subpaths(atPath: path)
            for fileName in childerFiles! {
                let absolutePath = "\(path)"+"/"+"\(fileName)"
                folderSize += self.getFileSizeWithPath( absolutePath)
            }
            return folderSize
        }
        return 0
    }
    
    /// 删除指定路径的cache 
    @discardableResult
    public func clearFolderWithPath(_ path: String) -> Bool {
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path as String) {
            let childerFiles = fileManager.subpaths(atPath: path)
            if (childerFiles?.count)! > 0 {
                for fileName in childerFiles! {
                    let absolutePath = "\(path)"+"/"+"\(fileName)"
                    do {
                        
                        try fileManager.removeItem(atPath: absolutePath)
                        
                    } catch {
                        
                    }
                }
            }
            return true
        }
        return false
    }
}
