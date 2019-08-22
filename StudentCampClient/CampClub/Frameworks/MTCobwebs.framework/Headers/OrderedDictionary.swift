//
//  OrderedDictionary.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation


/// 可排序的字典
public struct OrderedDictionary<KeyType: Hashable, ValueType> {

	typealias ArrayType = [KeyType]
	typealias DictionaryType = [KeyType: ValueType]

	var array = ArrayType()
	var dictionary = DictionaryType()
    
    /// 键值对数量
	public var count: Int {
		return self.array.count
	}

    /// 插入数据
    ///
    /// - Parameters:
    ///   - value: 值
    ///   - key: 键
    ///   - index: 下标
    /// - Returns: 值
	public mutating func insert(_ value: ValueType, forKey key: KeyType, atIndex index: Int) -> ValueType? {
		var adjustedIndex = index

		let existingValue = self.dictionary[key]
		if existingValue != nil {

			let existingIndex = self.array.index(of: key)!

			if existingIndex < index {
				adjustedIndex -= 1
			}
			self.array.remove(at: existingIndex)
		}

		self.array.insert(key, at: adjustedIndex)
		self.dictionary[key] = value

		return existingValue
	}

    /// 根据下标移除键值对
    ///
    /// - Parameter index:  下标
    /// - Returns: 键值对 (key,value)
	public mutating func removeAt(_ index: Int) -> (KeyType, ValueType) {
		precondition(index < self.array.count, "Index out-of-bounds")

		let key = self.array.remove(at: index)

		let value = self.dictionary.removeValue(forKey: key)!

		return (key, value)
	}

    
    /// 根据键获取对应值
    ///
    /// - Parameter key: 键
	public subscript(key: KeyType) -> ValueType? {

		get {
			return self.dictionary[key]
		}
		set {

			if let _ = self.array.index(of: key) {
			} else {
				self.array.append(key)
			}

			self.dictionary[key] = newValue
		}
	}

    /// 根据下标获取键值对
    ///
    /// - Parameter index: 下标
	public subscript(index: Int) -> (KeyType, ValueType) {
		get {
			precondition(index < self.array.count,
				"Index out-of-bounds")

			let key = self.array[index]

			let value = self.dictionary[key]!

			return (key, value)
		}
	}
}
