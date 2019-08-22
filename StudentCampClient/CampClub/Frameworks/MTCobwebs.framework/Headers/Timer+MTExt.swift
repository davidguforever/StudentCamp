//
//  NSTimer+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

private class BlockWrapper<T> {
	let block: T

	init(block: T) {
		self.block = block
	}
}

public extension Timer {
    
    /// 间隔执行事件
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - block: 处理事件
    ///   - repeats: 是否循环
    /// - Returns: Timer
	public static func scheduledTimer(_ interval: TimeInterval, block:  @escaping ((Timer) -> ()), repeats: Bool) -> Timer {
		let userInfo = BlockWrapper(block: block)

		return scheduledTimer(timeInterval: interval, target: self, selector: #selector(Timer.executeBlock(_:)), userInfo: userInfo, repeats: repeats)
	}
    
    /// execute block
    @objc public static func executeBlock(_ timer: Timer) {
		guard let wrapper = timer.userInfo as? BlockWrapper < (Timer) -> Void > else {
			return
		}

		wrapper.block(timer)
	}
}

public extension Timer {

	/// Runs every x seconds, to cancel use: timer.invalidate()
    public static func runThisEvery(seconds: TimeInterval, handler: @escaping (CFRunLoopTimer?) -> Void) -> Timer {
        let fireDate = CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
	/// Run function on main queue after x seconds
	public static func runThisAfterDelay(seconds: Double, after: @escaping () -> ()) {
		runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
	}

	// TODO: Make this easier
	/// dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
	public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> ()) {
		let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		queue.asyncAfter(deadline: time, execute: after)
	}

}



public extension Timer {
    
    // MARK: Schedule timers
    
    /// Create and schedule a timer that will call `block` once after the specified time.
    
    @discardableResult
    public static func after(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, block)
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    ///
    ///     Timer.every(5.seconds) { (timer: Timer) in
    ///         // do something
    ///
    ///         if finished {
    ///             timer.invalidate()
    ///         }
    ///     }
    @discardableResult
    public static func every(_ interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    /// Create and schedule a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    
    @nonobjc @discardableResult
    public static func every(_ interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, block)
        timer.start()
        return timer
    }
    
    // MARK: Create timers without scheduling
    
    /// Create a timer that will call `block` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    /// - Note: The `new` static function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    public static func new(after interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` static function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    public static func new(every interval: TimeInterval, _ block: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block()
        }
    }
    
    /// Create a timer that will call `block` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    /// - Note: The `new` static function is a workaround for a crashing bug when using convenience initializers (rdar://18720947)
    
    @nonobjc public static func new(every interval: TimeInterval, _ block: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            block(timer)
        }
        return timer
    }
    
    // MARK: Manual scheduling
    
    /// Schedule this timer on the run loop
    ///
    ///     let timer = Timer.new(every: 1.second) {
    ///         print("")
    ///     }
    ///     //then to start
    ///     timer.start()
    ///     timer.start(modes: .defaultRunLoopMode, .eventTrackingRunLoopMode)
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.
    
    public func start(runLoop: RunLoop = .current, modes: RunLoop.Mode...) {
        let modes = modes.isEmpty ? [RunLoop.Mode.default] : modes
        
        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}

// MARK: - Time extensions
extension Double {
    public var millisecond: TimeInterval  { return self / 1000 }
    public var milliseconds: TimeInterval { return self / 1000 }
    public var ms: TimeInterval           { return self / 1000 }
    
    public var second: TimeInterval       { return self }
    public var seconds: TimeInterval      { return self }
    
    public var minute: TimeInterval       { return self * 60 }
    public var minutes: TimeInterval      { return self * 60 }
    
    public var hour: TimeInterval         { return self * 3600 }
    public var hours: TimeInterval        { return self * 3600 }
    
    public var day: TimeInterval          { return self * 3600 * 24 }
    public var days: TimeInterval         { return self * 3600 * 24 }
}


