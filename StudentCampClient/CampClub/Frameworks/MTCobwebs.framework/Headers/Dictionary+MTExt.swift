//
//  Dictionary+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group

import Foundation

public extension Dictionary {
    // MARK: - Dictionary 基础

    /// 是否包含Key键
    ///
    /// - Parameter key: 键
    /// - Returns: 结果
	public func containsKey(_ key: Key) -> Bool {
		return self[key] != nil
    }
    
    /// 是否包含Key键 (Checks if a key exists in the dictionary.)
    ///
    /// - Parameter key: Key to check
    /// - Returns: true if the key exists
    public func has (_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    

    /// 初始化
	public init(dictionary: Dictionary<Key, Value>) {
		self.init(minimumCapacity: dictionary.count)
		addEntriesFrom(dictionary)
	}
    
    /// 追加Dictionary
	public mutating func addEntriesFrom(_ dictionary: Dictionary<Key, Value>) {
		for (key, value) in dictionary {
			self[key] = value
		}
	}

    /// 追加Dictionary
    ///
    /// - Parameter dictionary: dictionary
    /// - Returns: result Dictionary
	public func dictionaryByAddingEntiesFrom(_ dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
		var selfCopy = Dictionary(dictionary: self)
		selfCopy.addEntriesFrom(dictionary)
		return selfCopy
	}
    
    
    /// 转换JSON格式字符串  JSON String from dictionary.
    ///
    ///        dict.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
    ///
    ///        dict.jsonString(prettify: true)
    ///        /*
    ///        returns the following string:
    ///
    ///        "{
    ///        "testKey" : "testValue",
    ///        "testArrayKey" : [
    ///            1,
    ///            2,
    ///            3,
    ///            4,
    ///            5
    ///        ]
    ///        }"
    ///
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    public func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// 满足条件的个数  (Count dictionary entries that where function returns true.)
    ///
    /// - Parameter where: condition to evaluate each tuple entry against.
    /// - Returns: Count of entries that matches the where clousure.
    public func count(where condition: @escaping ((key: Key, value: Value)) throws -> Bool) rethrows -> Int {
        var count: Int = 0
        try self.forEach {
            if try condition($0) {
                count += 1
            }
        }
        return count
    }
    
    /// 移除指定键对应项
	public mutating func removeKeys < KeysSequenceType: Sequence> (_ keysToRemove: KeysSequenceType) -> Int where KeysSequenceType.Iterator.Element == Key  {
		var removedCount = 0
		var generator = keysToRemove.makeIterator()
		while let key: Key = generator.next() {
			if self.removeValue(forKey: key) != nil {
				removedCount += 1
			}
		}
		return removedCount
	}
    
    /// 移除指定Keys  (Remove all keys contained in the keys parameter from the dictionary.)
    ///
    ///        var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.removeAll(keys: ["key1", "key2"])
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed
    public mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }
    
    /// 从字典中删除随机密钥的值。 Remove a value for a random key from the dictionary.
    @discardableResult public mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }
}

public extension Dictionary {
    // MARK: - Dictionary merge
    
    
    /// 合并字典 (Create a new dictionary with the values of self and those of another dictionary.)
    ///
    /// - Parameter dictionary: Values of new dictionary will override those of self
    /// - Returns: Dictionary whose values to merge into self
	public func mergeWith(_ dictionary: Dictionary<Key, Value>) -> Dictionary<Key, Value>
	{
		var result: Dictionary<Key, Value> = self
		for (k, v) in dictionary { result.updateValue(v, forKey: k) }
		return result
	}

	func union(_ dictionary: Dictionary) -> Dictionary {
		return self.reduce(dictionary) { (d, p) in
            var dict = d
            dict[p.0] = p.1
			return dict
		}
	}
    
    
    /// 得到与另一字典不同的新字典 (Difference of self and the input dictionaries.)
    ///  Two dictionaries are considered equal if they contain the same [key: value] pairs.
    /// - Parameter dictionaries: dictionaries Dictionaries to subtract
    /// - Returns: Difference of self and the input dictionaries
    public func difference <V: Equatable> (_ dictionaries: [Key: V]...) -> [Key: V] {
        
        var result = [Key: V]()
        
        each {
            if let item = $1 as? V {
                result[$0] = item
            }
        }
        
        //  Difference
        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if result.has(key) && result[key] == value {
                    result.removeValue(forKey: key)
                }
            }
        }
        
        return result
        
    }
    
    /// 循环执行 (Loops trough each [key: value] pair in self.)
    public func each (_ each: (Key, Value) -> ()) {
        
        for (key, value) in self {
            each(key, value)
        }
        
    }
    

}

// MARK: - Operators
public extension Dictionary {
    
    /// 合并两个词典的键/值。(Merge the keys/values of two dictionaries.)
    ///
    ///        let dict : [String : String] = ["key1" : "value1"]
    ///        let dict2 : [String : String] = ["key2" : "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
    
    // MARK: - Operators
    /// 将第二个字典中的键和值附加到第一个字典中。(Append the keys and values from the second dictionary into the first one.)
    ///
    ///        var dict : [String : String] = ["key1" : "value1"]
    ///        let dict2 : [String : String] = ["key2" : "value2"]
    ///        dict += dict2
    ///        dict["key1"] -> "value1"
    ///        dict["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    public static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }
    
    /// 从字典中删除包含在数组中的内容。 (Remove contained in the array from the dictionary)
    ///
    ///        let dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        let result = dict-["key1", "key2"]
    ///        result.keys.contains("key3") -> true
    ///        result.keys.contains("key1") -> false
    ///        result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    public static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }
    
    /// 从字典中删除包含在数组中的内容。 (Remove contained in the array from the dictionary)
    ///
    ///        var dict : [String : String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict-=["key1", "key2"]
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    public static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }
    
}

/// 两个字典相加
///
/// - Parameters:
///   - lhs: [KeyType: ValueType]
///   - rhs: [KeyType: ValueType]
/// - Returns: [KeyType: ValueType]
public func + <KeyType, ValueType>(lhs: [KeyType: ValueType], rhs:[KeyType: ValueType])
	-> [KeyType: ValueType]
{
	return lhs.mergeWith(rhs)
}

/// 追加一个字典
///
/// - Parameters:
///   - lhs: [KeyType: ValueType]
///   - rhs: [KeyType: ValueType]
/// - Returns: [KeyType: ValueType]
public func += <KeyType, ValueType> (lhs: inout [KeyType: ValueType], rhs: [KeyType: ValueType]) {
//public func += <K: Hashable, V: Any>(lhs: inout Dictionary<K, V>, rhs: Dictionary<K, V>) {
	lhs = lhs + rhs
}


/// 判断字典是否相同
///
/// - Parameters:
///   - lhs: 字典
///   - rhs: 字典
/// - Returns: true or false
public func == (lhs: [String: Any], rhs: [String: Any] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

/// 判断字典是否相同
///
/// - Parameters:
///   - lhs: 字典
///   - rhs: 字典
/// - Returns: true or false
public func == <K, V>(left: [K:V], right: [K:V]) -> Bool {
    return NSDictionary(dictionary: left).isEqual(to: right)
}

/// 判断字典是否相同
///
/// - Parameters:
///   - lhs: 字典
///   - rhs: 字典
/// - Returns: true or false
public func == <K, V>(left: [K:V?], right: [K:V?]) -> Bool {
    guard let left = left as? [K: V], let right = right as? [K: V] else { return false }
    return NSDictionary(dictionary: left).isEqual(to: right)
}

public extension Dictionary {

    /// It's not uncommon to want to turn a sequence of values into a dictionary,
    ///    where each value is keyed by some unique identifier. This initializer will
    ///    do that.
    ///
    ///    - parameter sequence: The sequence to be iterated
    ///    - parameter keyer: The closure that will be executed for each element in
    ///    the `sequence`. The return value of this closure, if there is one, will
    ///    be used as the key for the value in the `Dictionary`. If the closure
    ///    returns `nil`, then the value will be omitted from the `Dictionary`.
	public init < Sequence: Swift.Sequence> (sequence: Sequence, keyMapper: (Value) -> Key?) where Sequence.Iterator.Element == Value  {
		self.init()

		for item in sequence {
			if let key = keyMapper(item) {
				self[key] = item
			}
		}
	}
    
}

extension Dictionary {
    /// Returns a dictionary containing the results of mapping the given closure over the sequence’s elements.
    /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and returns a transformed value of the same or of a different type.
    /// - Returns: A dictionary containing the transformed elements of this sequence.
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try map(transform))
    }
    
    /// Returns a dictionary containing the non-`nil` results of calling the given transformation with each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
    /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return [K: V](uniqueKeysWithValues: try compactMap(transform))
    }
}

// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: StringProtocol {
    
    /// 让所有key小写 (Lowercase all keys in dictionary.)
    ///
    ///        var dict = ["tEstKeY": "value"]
    ///        dict.lowercaseAllKeys()
    ///        print(dict) // prints "["testkey": "value"]"
    ///
    public mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
    
}

public extension Dictionary where Value : Equatable  {
    /// 得到相同Value的键数组
    public func allKeysForValue(_ val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
    
    public init(_ seq: Zip2Sequence<[Key], [Value]>) {
        self.init()
        for (k,v) in seq {
            self[k] = v
        }
    }
}


