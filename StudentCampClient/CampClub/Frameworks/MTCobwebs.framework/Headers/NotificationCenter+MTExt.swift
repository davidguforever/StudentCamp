//
//  NSNotificationCenter+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation

public extension NotificationCenter {
    
    /// NSNotificationCenter.addObserverForName with default parameters
    @discardableResult
    public static func addObserverWithName(_ name: String,
                                    object obj: Any? = nil,
                                           queue: OperationQueue? = nil,
                                           usingBlock block: @escaping (Notification) -> Void) -> NSObjectProtocol
    {
        return NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: obj, queue: queue, using: block)
    }
    
    /// NSNotificationCenter.addObserverForName with default parameters
    @discardableResult
    public static func addObserver(_ name: NSNotification.Name,
                                    object obj: Any? = nil,
                                    queue: OperationQueue? = nil,
                                    usingBlock block: @escaping (Notification) -> Void) -> NSObjectProtocol
    {
        return NotificationCenter.default.addObserver(forName: name, object: obj, queue: queue, using: block)
    }
    
    
    /// Applying NSNotificationCenter.addObserverWithName for all the notifications in `names`
    @discardableResult
    public static func addObserverWithNames(_ names: [String],
                                     object obj: Any? = nil,
                                            queue: OperationQueue? = nil,
                                            usingBlock block: @escaping (Notification) -> Void) -> [NSObjectProtocol]
    {
        return names.map { NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: $0), object: obj, queue: queue, using: block) }
    }
    
    /// Applying NSNotificationCenter.addObserverWithName for all the notifications in `names`
    @discardableResult
    public static func addObserverWith(_ names: [NSNotification.Name],
                                     object obj: Any? = nil,
                                     queue: OperationQueue? = nil,
                                     usingBlock block: @escaping (Notification) -> Void) -> [NSObjectProtocol]
    {
        return names.map { NotificationCenter.default.addObserver(forName: $0, object: obj, queue: queue, using: block) }
    }
    
    /// Applying NSNotificationCenter.removeObserver to list of observers
    public static func removeObservers(_ observers: [Any])
    {
        observers.forEach {
            NotificationCenter.default.removeObserver($0)
        }
    }
}


