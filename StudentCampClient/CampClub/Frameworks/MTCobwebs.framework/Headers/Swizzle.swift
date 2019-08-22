
//  Swizzler.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation


/// IMP Swizzler
public class Swizzler {
    static var swizzles = [Method: Swizzle]()
    
    static func printSwizzles() {
        for (_, swizzle) in swizzles {
            MT.print( "\(swizzle)")
            
        }
    }
    
    public static func getSwizzle(for method: Method) -> Swizzle? {
        return swizzles[method]
    }
    
    public static func removeSwizzle(for method: Method) {
        swizzles.removeValue(forKey: method)
    }
    
    public static func setSwizzle(_ swizzle: Swizzle, for method: Method) {
        swizzles[method] = swizzle
    }
    
    public static func swizzleSelector(_ originalSelector: Selector,
                               withSelector newSelector: Selector,
                               for aClass: AnyClass,
                               name: String,
                               block: @escaping ((_ view: AnyObject?,
        _ command: Selector,
        _ param1: AnyObject?,
        _ param2: AnyObject?) -> Void)) {
        
        if let originalMethod = class_getInstanceMethod(aClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(aClass, newSelector) {
            
            var swizzle = getSwizzle(for: originalMethod)
            if swizzle == nil {
                swizzle = Swizzle(block: block,
                                  name: name,
                                  aClass: aClass,
                                  selector: originalSelector,
                                  originalMethod: method_getImplementation(originalMethod))
                setSwizzle(swizzle!, for: originalMethod)
            } else {
                swizzle?.blocks[name] = block
            }
            
            let didAddMethod = class_addMethod(aClass,
                                               originalSelector,
                                               method_getImplementation(swizzledMethod),
                                               method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                setSwizzle(swizzle!, for: class_getInstanceMethod(aClass, originalSelector)!)
            } else {
                method_setImplementation(originalMethod, method_getImplementation(swizzledMethod))
            }
        } else {
            MT.print( "Swizzling error: Cannot find method for "
                + "\(NSStringFromSelector(originalSelector)) on \(NSStringFromClass(aClass))")
        }
    }
    
    public static func unswizzleSelector(_ selector: Selector, aClass: AnyClass, name: String? = nil) {
        if let method = class_getInstanceMethod(aClass, selector),
            let swizzle = getSwizzle(for: method) {
            if let name = name {
                swizzle.blocks.removeValue(forKey: name)
            }
            
            if name == nil || swizzle.blocks.count < 1 {
                method_setImplementation(method, swizzle.originalMethod)
                removeSwizzle(for: method)
            }
        }
    }
    
}

public class Swizzle: CustomStringConvertible {
    let aClass: AnyClass
    let selector: Selector
    let originalMethod: IMP
    var blocks = [String: ((view: AnyObject?, command: Selector, param1: AnyObject?, param2: AnyObject?) -> Void)]()
    
    public init(block: @escaping ((_ view: AnyObject?, _ command: Selector, _ param1: AnyObject?, _ param2: AnyObject?) -> Void),
         name: String,
         aClass: AnyClass,
         selector: Selector,
         originalMethod: IMP) {
        self.aClass = aClass
        self.selector = selector
        self.originalMethod = originalMethod
        self.blocks[name] = block
    }
    
    public var description: String {
        var retValue = "Swizzle on \(NSStringFromClass(type(of: self)))::\(NSStringFromSelector(selector)) ["
        for (key, value) in blocks {
            retValue += "\t\(key) : \(value)\n"
        }
        return retValue + "]"
    }
    
    
}
