//
//  Numberal+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation
public typealias IndexHandler = (_ number: Int) -> Void


public extension Int { // : NumeralExtension {
    /// 是否偶数
    public var isEven: Bool { return (self % 2 == 0) }
    
    
    /// 在区间内获取随机数  建议使用 `RandomAccessCollection.random`
    public static func random(from range: Range<Int>) -> Int {
        let distance = range.upperBound - range.lowerBound
        let rnd = arc4random_uniform(UInt32(distance))
        return range.lowerBound + Int(rnd)
    }

    
    /// 随机数  Random integer between min and max (inclusive).
    ///
    /// - Parameters:
    ///   - min: 最小值 默认 :0  min Minimum value to return
    ///   - max: 最大值  max Maximum value to return
    /// - Returns: 值 Random integer
    public static func random(_ min: Int = 0, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
    }

    
    ///
    ///
    /// - Parameter toValue:  最大数
    /// - Returns: 从 self..<toValue 获取随机数
	public func randomBetween(_ toValue: Int) -> Int {
		let minValue = toValue < self ? toValue : self
		let maxValue = toValue > self ? toValue : self
		return Int.random( minValue, max: maxValue)
	}


    
    /// 获取靠近某一区间值  如： self = 10,  [2,6] -> 6; [20,100]->20; [5,20]->10
    ///
    /// - Parameters:
    ///   - min: 小值
    ///   - max: 大值
    /// - Returns: 结果
	public func clamp(min: Int, max: Int) -> Int {
		assert(min < max, "Minimum  has to be less than the maximum")
		var properValue = self
		if self > max { properValue = max }
		else if self < min { properValue = min }
		return properValue
	}

    
    /// 执行某一事件，次数为当前值 警告：self 必须大于0
    ///
    /// - Parameter block: 事件
    /// - Returns:  1..<self
    @discardableResult
	public func times(_ block: IndexHandler) -> CountableRange<Int> {
		assert(self > 0, "Self to be more than 0")
		for index in 1 ..< self {
			block(index)
		}

		return 1 ..< self // Range(start: 1, end: self)
    }
    
    /// 执行某一事件，次数为 (toValue -当前值) 警告：self 必须小于 toValue
    ///
    /// - Parameters:
    ///   - toValue: 目标值
    ///   - block: 事件
    /// - Returns: self..<toValue
    @discardableResult
	public func upto(_ toValue: Int, _ block: IndexHandler) -> CountableRange<Int> {
		assert(self < toValue, "Starting value has to be less than the to-value")
		for index in self ..< toValue {
			block(Int(index))
		}

		return self ..< toValue // Range(start: self, end: toValue)
	}

    /// 执行某一事件，次数为 (当前值 - toValue) 警告：self 必须大于 toValue
    ///
    /// - Parameters:
    ///   - toValue: 目标值
    ///   - block: 事件
    /// - Returns: self..<toValue
    @discardableResult
	public func downto(_ toValue: Int, _ block: IndexHandler) -> CountableRange<Int> {
		assert(self > toValue, "Starting value has to be more than the to-value")

		for index in (toValue ... self).reversed() {
			block(Int(index))
		}

		return toValue ..< self // Range(start: self, end: toValue)
	}

}

public extension RandomAccessCollection {
    
    /// 在区间范围中获取随机数
    ///
    ///         (1..<10).random()
    ///         (1...9).random()
    ///
    /// - Returns: 结果
    public func random() -> Iterator.Element? {
        guard count > 0 else { return nil }
        let offset = arc4random_uniform(numericCast(count))
        let i = index(startIndex, offsetBy: numericCast(offset))
        return self[i]
    }
}
