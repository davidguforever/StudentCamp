//
//  MTTimer.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//


import Foundation


/// MTTimer
public class MTTimer {
    
    private let internalTimer: DispatchSourceTimer
    
    private var isRunning = false
    
    /// 是否循环
    public let repeats: Bool
    
    /// block : (MTTimer) -> Void
    public typealias MTTimerHandler = (MTTimer) -> Void
    
    private var handler: MTTimerHandler
    
    
    /// init
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - repeats: 是否循环 默认：false
    ///   - queue: 线程  默认：主线程
    ///   - handler: 事件
    public init(_ interval: DispatchTimeInterval, repeats: Bool = false, queue: DispatchQueue = .main , handler: @escaping MTTimerHandler) {
        
        self.handler = handler
        self.repeats = repeats
        internalTimer = DispatchSource.makeTimerSource(queue: queue)
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            internalTimer.schedule(deadline: .now() + interval)
        }
    }
    /// 创建循环Timer
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - queue: 线程  默认：主线程
    ///   - handler: 事件
    /// - Returns: Self
    public static func repeaticTimer(_ interval: DispatchTimeInterval, queue: DispatchQueue = .main , handler: @escaping MTTimerHandler) -> MTTimer {
        return MTTimer( interval, repeats: true, queue: queue, handler: handler)
    }
    
    deinit {
        if !self.isRunning {
            internalTimer.resume()
        }
    }
    
    /// 重启 (您可以使用此方法来触发重复计时器，而不中断其正常触发计划。 如果定时器不重复，则它在触发后自动无效，即使其预定的开始日期尚未到达。)
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            internalTimer.cancel()
        }
    }
    /// 开始，继续
    public func start() {
        if !isRunning {
            internalTimer.resume()
            isRunning = true
        }
    }
    /// 暂停
    public func suspend() {
        if isRunning {
            internalTimer.suspend()
            isRunning = false
        }
    }
    
    /// reschedule Repeating
    public func rescheduleRepeating(interval: DispatchTimeInterval) {
        if repeats {
            internalTimer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    /// reschedule Handler
    public func rescheduleHandler(handler: @escaping MTTimerHandler) {
        self.handler = handler
        internalTimer.setEventHandler { [weak self] in
            if let strongSelf = self {
                handler(strongSelf)
            }
        }
        
    }
}

//MARK: Throttle
public extension MTTimer {
    
    private static var timers = [String: DispatchSourceTimer]()
    
    public static func throttle(interval: DispatchTimeInterval, identifier: String, queue: DispatchQueue = .main , handler:  @escaping () -> Void ) {
        
        if let previousTimer = timers[identifier] {
            previousTimer.cancel()
        }
        
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(deadline: .now() + interval)
        timer.setEventHandler {
            handler()
            timer.cancel()
            timers.removeValue(forKey: identifier)
        }
        timer.resume()
        timers[identifier] = timer
    }
}

//MARK: Count Down

/// 倒计时Timer
public class MTCountDownTimer {
    
    private let internalTimer: MTTimer
    
    private var leftTimes: Int
    
    private let originalTimes: Int
    
    private let handler: (MTCountDownTimer, _ leftTimes: Int) -> Void

    
    /// 初始化倒计时
    ///
    ///         let timer = MTCountDownTimer(interval: .fromSeconds(0.1), times: 10) { timer , leftTimes in
    ///            label.text = "\(leftTimes)"
    ///         }
    ///         timer.start()
    /// 
    /// - Parameters:
    ///   - interval: 时间
    ///   - times: 次数
    ///   - queue: 线程  default = .main
    ///   - handler: 回调
    public init(interval: DispatchTimeInterval, times: Int,queue: DispatchQueue = .main , handler:  @escaping (MTCountDownTimer, _ leftTimes: Int) -> Void ) {
        
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.internalTimer = MTTimer.repeaticTimer( interval, queue: queue, handler: { _ in
        })
        self.internalTimer.rescheduleHandler { [weak self]  swiftTimer in
            if let strongSelf = self {
                if strongSelf.leftTimes > 0 {
                    strongSelf.leftTimes = strongSelf.leftTimes - 1
                    strongSelf.handler(strongSelf, strongSelf.leftTimes)
                } else {
                    strongSelf.internalTimer.suspend()
                }
            }
        }
    }
    
    /// 开始
    public func start() {
        self.internalTimer.start()
    }
    /// 暂停
    public func suspend() {
        self.internalTimer.suspend()
    }
    /// 重启
    public func reCountDown() {
        self.leftTimes = self.originalTimes
    }
    
}


public extension DispatchTimeInterval {
    
    /// convert Double to DispatchTimeInterval
    public static func fromSeconds(_ seconds: Double) -> DispatchTimeInterval {
        return .nanoseconds(Int(seconds * Double(NSEC_PER_SEC)))
    }
}

// MARK: 轻松地使用 DispatchTime
extension DispatchTime: ExpressibleByIntegerLiteral {
    
    /// 轻松地使用 DispatchTime
    ///
    ///         DispatchQueue.main.asyncAfter(deadline: 5) { /* ... */ }
    ///
    /// - Parameter value: seconds
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    /// 轻松地使用 DispatchTime
    ///
    ///         DispatchQueue.main.asyncAfter(deadline: 1.5) { /* ... */ }
    /// - Parameter value: seconds
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}


 
