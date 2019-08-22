//
//  String+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation
import UIKit

public extension String {

	/// Checking if String contains input
	public func contains(_ find: String) -> Bool {
		return self.range(of: find) != nil
	}

	/// Checking if String contains input with comparing options
	public func contains(_ find: String, compareOption: NSString.CompareOptions) -> Bool {
		return self.range(of: find, options: compareOption) != nil
	}
}

public extension String {

    /// 拼接路径字符串
	func appendingPathComponent(_ path: String) -> String {
		return (self as NSString).appendingPathComponent(path)
	}
    

    /// NSString lastPathComponent.
    public var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    
    /// 随机字符串  数字大小写随机
    ///
    /// - Parameter length: 长度 默认：1
    /// - Returns: string
    static func random(length: Int = 1) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0 ..< length {
            randomString.append(base.randomElement()!)
        }
        
        return randomString
    }
    
    /// 初始化随机字符串 Create a new random string of given length.
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    public init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        self = randomString
    }
}

// MARK: - Date
public extension String {

    /// 字符串转变日期
    /// to format: yyyy-MM-dd HH:mm:ss
    /// - Returns: Date
	public func toDate() -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

		if let date = dateFormatter.date(from: self) {
			return date
		} else {
			return nil
		}
	}
    
    /// yyyy-MM-dd 转成Date ( Date object from "yyyy-MM-dd" formatted string)
    public var date: Date? {
        let selfLowercased = self.trimming(.whitespace).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    ///  yyyy-MM-dd HH:mm:ss 转成Date ( Date object from "yyyy-MM-dd HH:mm:ss" formatted string.)
    public var dateTime: Date? {
        let selfLowercased = self.trimming(.whitespace).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
}

public extension String {
    // MARK: - Trim
    
    
    /// 截取类型
    ///
    /// - whitespace: 空格
    /// - whitespaceAndNewline: 空格和换行符
    public enum TrimmingType {
        /// 空格
		case whitespace
        /// 空格和换行符
		case whitespaceAndNewline
	}
    
    /// 截取
    ///
    /// - Parameter trimmingType: 截取类型 `TrimmingType`
    /// - Returns: 结果字符串
	public func trimming(_ trimmingType: TrimmingType) -> String {
		switch trimmingType {
		case .whitespace:
			return trimmingCharacters(in: CharacterSet.whitespaces)
		case .whitespaceAndNewline:
			return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		}
	}
    
    /// 删除字符串开头和结尾的空格和新行。 (Removes spaces and new lines in beginning and end of string.)
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    public mutating func trim() {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 从字符串移除换行符 \n
	public var removeAllNewLines: String {
		return self.components(separatedBy: CharacterSet.newlines).joined(separator: "")
	}

    /// 截取后拼接  适用于:介绍，简介  如  str.mt_truncate(120, trailing: "...")
    ///
    /// - Parameters:
    ///   - length: 长度
    ///   - trailing: 末尾拼接字符串  默认 nil
    /// - Returns: 结果字符串
	public func mt_truncate(_ length: Int, trailing: String? = nil) -> String {
		if self.count > length {
			return String(self[0..<length]) + (trailing ?? "")
		} else {
			return self
		}
	}

    /// Readable string from a URL string.
    public var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// 网址转义字符串。(URL escaped string.)
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    public var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
    
    /// 截取字符串 (Sliced string from a start index with length.)
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///        "Hello World".slicing(length: 5) -> "Hello"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from. default: 0
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    public func slicing(from i: Int = 0, length: Int) -> String? {
        guard length >= 0, i >= 0, i < count  else { return nil }
        guard i.advanced(by: length) <= count else {
            return self[safe: i..<count]
        }
        guard length > 0 else { return "" }
        return self[safe: i..<i.advanced(by: length)]
    }
    
    /// 截取字符串 (Slice given string from a start index with length (if applicable).)
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    public mutating func slice(from i: Int, length: Int) {
        if let str = self.slicing(from: i, length: length) {
            self = String(str)
        }
    }
    
    /// 截取字符串 (Slice given string from a start index to an end index (if applicable).)
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    /// - Parameters:
    ///   - start: string index the slicing should start from.
    ///   - end: string index the slicing should end at.
    public mutating func slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        if let str = self[safe: start..<end] {
            self = str
        }
    }
    
    /// 截取字符串 (Slice given string from a start index (if applicable).)
    ///
    ///        var str = "Hello World"
    ///        str.slice(at: 6)
    ///        print(str) // prints "World"
    ///
    /// - Parameter i: string index the slicing should start from.
    public mutating func slice(at i: Int) {
        guard i < count else { return }
        if let str = self[safe: i..<count] {
            self = str
        }
    }
    
    /// 检查字符串是否以子字符串开头。(Check if string starts with substring.)
    ///
    ///        "hello World".starts(with: "h") -> true
    ///        "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    public func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
}

// MARK: - Operators
public extension String {
    
    ///  Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    public static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }
    
    ///  Repeat string multiple times.
    ///
    ///        3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    public static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
    
}

public extension String {
    #if os(iOS) || os(macOS)
    /// Copy string to global pasteboard.
    public func copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general().setString(self, forType: NSPasteboardTypeString)
        #endif
    }
    #endif
    
    /// Init string with a base64 encoded string
    public init ? (base64: String) {
        let pad = String(repeating: "=", count: base64.length % 4)
        let base64Padded = base64 + pad
        if let decodedData = Data(base64Encoded: base64Padded, options: NSData.Base64DecodingOptions(rawValue: 0)), let decodedString = NSString(data: decodedData, encoding: String.Encoding.utf8.rawValue) {
            self.init(decodedString)
            return
        }
        return nil
    }
    
    /// base64 encoded of string
    public var base64: String {
        let plainData = (self as NSString).data(using: String.Encoding.utf8.rawValue)
        let base64String = plainData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    /// 获取嵌入的路径集合
	public var mt_embeddedURLs: [URL] {

		guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
			return []
		}

		var URLs = [URL]()

		detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, (self as NSString).length)) { result, flags, stop in

			if let URL = result?.url {
				URLs.append(URL)
			}
		}

		return URLs
	}

    
    /// 中文转为英文
	var change2English: String {
		let mutableString = NSMutableString(string: self) as CFMutableString
		// 先转换为带声调的拼音
		CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
		// 再转换为不带声调的拼音
		CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)

		return mutableString as String
	}

    /// 获取拼音首字母
	var firstCharactor: String? {
		// 转成了可变字符串
		let mutableString: NSMutableString = NSMutableString(string: self)
		// 先转换为带声调的拼音
		CFStringTransform(mutableString, nil, kCFStringTransformMandarinLatin, false)
		// 再转换为不带声调的拼音
		CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
		// 转化为大写拼音
		let pinYin: String = mutableString.capitalized
		// return pinYin.substringToIndex(pinYin.startIndex.advancedBy(1)) //pinYin.startIndex.successor())
		return pinYin[0..<1]
	}

    
}

public extension String {
    /// CamelCase of string.
    ///
    ///        "sOme vAriable naMe".camelCased -> "someVariableName"
    ///
    public var camelCased: String {
        let source = lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    
    /// 截取空格和换行符  String with no spaces or new lines in beginning and end.
    ///
    ///        "   hello  \n".trimmed -> "hello"
    ///
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    public var bool: Bool? {
        let selfLowercased = trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }

    
    /// encode Emoji 如："Hello 😃.".stringToUnicode -> Hello \ud83d\ude03.
    public var stringToUnicode: String {
        get {
            if let data = self.data(using: String.Encoding.nonLossyASCII, allowLossyConversion: true) {
                if let convertedString = String(data: data, encoding: String.Encoding.utf8) {
                    return convertedString
                }
            }
            
            return self
        }
    }
    
    /// decode Emoji 如："Hello \ud83d\ude03.".unicodeToString -> Hello 😃.
    public var unicodeToString: String {
        get {
            if let data =  self.data(using: String.Encoding.utf8, allowLossyConversion: true) {
                if let convertedString = String(data: data, encoding: String.Encoding.nonLossyASCII) {
                    return convertedString
                }
            }
            
            return self
        }
    }
    
    /// Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    public var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
                0x1F600...0x1F64F, // Emoticons
                0x1F300...0x1F5FF, // Misc Symbols and Pictographs
                0x1F680...0x1F6FF, // Transport and Map
                0x2600...0x26FF,   // Misc symbols
                0x2700...0x27BF,   // Dingbats
                0xFE00...0xFE0F,   // Variation Selectors
                0x1F900...0x1F9F,   // Various (e.g. 🤖)
                65024...65039, // Variation selector
                8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 首字符 First character of string (if applicable).
    public var firstCharacter: String? {
        return Array(self).map({String($0)}).first
    }
    
    /// 是否包含小写字母 Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    public var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// 是否只有字母  Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    public var isAlphabetic: Bool {
        return  hasLetters && !hasNumbers
    }
    
    /// 是否是字母和数字组合  Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    public var isAlphaNumeric: Bool {
        return components(separatedBy: CharacterSet.alphanumerics).joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    

    /// Check if string is a valid URL.
    ///
    ///          public var isEmail: Bool {
    ///              // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    ///              let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    ///              let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    ///              return emailTest.evaluate(with: self)
    ///          }
    ///
    public var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /// Check if string is a valid https URL.
    public var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "https"
    }
    
    /// Check if string is a valid http URL.
    public var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else {
            return false
        }
        return url.scheme == "http"
    }
    
    /// Check if string is a valid schemed URL.
    ///
    ///        "https://google.com".isValidSchemedUrl -> true
    ///        "google.com".isValidSchemedUrl -> false
    ///
    public var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    
    /// Check if string contains only numbers.
    ///
    ///        "123".isNumeric -> true
    ///        "abc".isNumeric -> false
    ///
    public var isNumeric: Bool {
        return  !hasLetters && hasNumbers
    }
    
    /// Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    public var lastCharacter: String? {
        guard let last = last else {
            return nil
        }
        return String(last)
    }
    
    /// 拉丁字符串  Latinized string.
    ///
    ///        "Hèllö Wórld!".latinized -> "Hello World!"
    ///
    public var latinized: String {
        return folding(options: .diacriticInsensitive, locale: Locale.current)
    }
    

    /// 空格和换行符的数量  Array of strings separated by new lines.
    public var lines: [String] {
        var result:[String] = []
        enumerateLines { (line, stop) -> () in
            result.append(line)
        }
        return result
    }
    
    /// The most common character in string.
    public var mostCommonCharacter: String {
        var mostCommon = ""
        let charSet = Set(withoutSpacesAndNewLines.map{String($0)})
        var count = 0
        for string in charSet {
            if self.count(of: string) > count {
                count = self.count(of: string)
                mostCommon = string
            }
        }
        return mostCommon
    }
    
    /// Reversed string.
    public var reversed: String {
        return String(reversed())
    }
    
    /// String without spaces and new lines.
    public var withoutSpacesAndNewLines: String {
        return replacing(" ", with: "").replacing("\n", with: "")
    }
    
    /// String by replacing part of string with another string.
    ///
    /// - Parameters:
    ///   - substring: old substring to find and replace.
    ///   - newString: new string to insert in old string place.
    /// - Returns: string after replacing substring with newString.
    public func replacing(_ substring: String, with newString: String) -> String {
        return replacingOccurrences(of: substring, with: newString)
    }
}

public extension String {
    // MARK: - Cut Check
    
    
    ///  an array of all words in a string
    ///
    ///        "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    public func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    ///  Count of words in a string.
    ///
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    public func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        return words().count
    }
    
    
    
    // MARK: - Cut Check
    
    /// 根据下标获取字符 (Cut string from integerIndex to the end)
    public subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    /// 范围截取 (Cut string from range)
    public subscript(integerRange: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = self.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start ..< end
        return String(self[range])
    }

    
    ///  Safely subscript string with index.
    ///
    ///        "Hello World!"[3] -> "l"
    ///        "Hello World!"[20] -> nil
    ///
    /// - Parameter i: index.
    public subscript(safe i: Int) -> Character? {
        guard i >= 0 && i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
    
    ///  在半开范围内安全地获取字符串。 Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[6..<11] -> "World"
    ///        "Hello World!"[21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    public subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    ///  在范围内安全地获取字符串。Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[6...11] -> "World!"
    ///        "Hello World!"[21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    public subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// 从字符串中删除给定的前缀。Removes given prefix from the string.
    ///
    ///   "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    public func removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    ///  从字符串中删除给定的后缀。Removes given suffix from the string.
    ///
    ///   "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    public func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
	/// 长度 （Character count）
	public var length: Int {
		return self.count
	}
    
    /// 返回字符串中段落的数量。(Returns count of paragraphs in string)
    public var countofParagraphs: Int {
        let regex = try? NSRegularExpression(pattern: "\\n", options: NSRegularExpression.Options())
        let str = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (regex?.numberOfMatches(in: str, options: NSRegularExpression.MatchingOptions(), range: NSRange(location:0, length: str.length)) ?? -1) + 1
    }
    

    
	/// 指定字符串的数量  (Counts number of instances of the input inside String)
	public func count(of substring: String) -> Int {
		return components(separatedBy: substring).count - 1
	}
    
    /// 指定字符串的数量  Count of substring in string.
    ///
    ///        "Hello World!".count(of: "o") -> 2
    ///        "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: 为区分大小写的搜索设置为true（默认为true）。set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    public func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    
    /// 检查字符串是否以子字符串结尾。(Check if string ends with substring.)
    ///
    ///        "Hello World!".ends(with: "!") -> true
    ///        "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    public func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// 替换字符串。(replace string)
	public func replace(_ target: String, withString: String) -> String {
		return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
	}
	/// 让首字母大写 (Capitalizes first character of String)
	public var capitalizeFirst: String {
		var result = self
		result.replaceSubrange(startIndex ... startIndex, with: String(self[startIndex]).capitalized)
		return result
	}
    
    /// 判断是否空  "".isEmpty() -> true
	public func isEmpty() -> Bool {
		return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0
	}
    

	/// 是否只是空格和换行符
	public func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
		let characterSet = CharacterSet.whitespacesAndNewlines
		let newText = self.trimmingCharacters(in: characterSet)
		return newText.isEmpty
	}

    #if canImport(Foundation)
    /// Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///        "john@doe.com".isValidEmail -> true
    ///
    public var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif
    
	/// 检查是否Email格式 (Checks if String contains Email)
	public var isEmail: Bool {
		let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length))
		return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
	}

	/// 检查是否数字格式 (Returns if String is a number)
	public func isNumber() -> Bool {
		if let _ = NumberFormatter().number(from: self) {
			return true
		}
		return false
	}

	/// 提取字符串URLS (Extracts URLS from String)
	public var extractURLs: [URL] {
		var urls: [URL] = []
		let detector: NSDataDetector?
		do {
			detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
		} catch _ as NSError {
			detector = nil
		}

		let text = self

		detector!.enumerateMatches(in: text, options: [], range: NSMakeRange(0, text.count), using: {
			(result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			urls.append(result!.url!)
		})

		return urls
	}

    /// 检查是否可转Int Check this string is pure integer or not
	public func isPureInt() -> Bool {
		let scan: Scanner = Scanner(string: self as String)
		var val: Int = 0
		return scan.scanInt(&val) && scan.isAtEnd
	}


    /// 检查是否可转Double Check this string is pure float or not
	public func isPureDouble() -> Bool {
		let scan: Scanner = Scanner(string: self as String)
		var val: Double = 0.0
		return scan.scanDouble(&val) && scan.isAtEnd
	}

	/// Converts String to Int
	public func toInt() -> Int? {
		if let num = NumberFormatter().number(from: self) {
			return num.intValue
		} else {
			return nil
		}
	}

	/// Converts String to Double
	public func toDouble() -> Double? {
		if let num = NumberFormatter().number(from: self) {
			return num.doubleValue
		} else {
			return nil
		}
	}

	/// Converts String to Float
	public func toFloat() -> Float? {
		if let num = NumberFormatter().number(from: self) {
			return num.floatValue
		} else {
			return nil
		}
	}


	/// Returns the first index of the occurency of the character in String
	public func getIndexOf(_ char: Character) -> Int? {
		for (index, c) in enumerated() {
			if c == char {
				return index
			}
		}
		return nil
	}

	/// Converts String to NSString
	public var toNSString: NSString { get { return self as NSString } }

    // MARK: - NSAttributedString
    
	/// Returns bold NSAttributedString
	public func bold() -> NSAttributedString {
        let boldString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
		return boldString
	}

	/// Returns underlined NSAttributedString
	public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
		return underlineString
	}

	/// Returns italic NSAttributedString
	public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
		return italicString
	}

	/// Returns NSAttributedString
	public func color(_ color: UIColor) -> NSAttributedString {
        let colorString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
		return colorString
	}

}
