//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


import Foundation

/*
 func aaa() {
    ("ddd" =~ "\\w+").boolValue
}
 
 */
infix operator =~


public func =~ (value : String, pattern : String) -> RegexMatchResult {
    let nsstr = value as NSString // we use this to access the NSString methods like .length and .substringWithRange(NSRange)
    let options : NSRegularExpression.Options = []
    do {
        let re = try  NSRegularExpression(pattern: pattern, options: options)
        let all = NSRange(location: 0, length: nsstr.length)
        var matches : Array<String> = []
        re.enumerateMatches(in: value, options: [], range: all) { (result, flags, ptr) -> Void in
            guard let result = result else { return }
            let string = nsstr.substring(with: result.range)
            matches.append(string)
        }
        return RegexMatchResult(items: matches)
    } catch {
        return RegexMatchResult(items: [])
    }
}

public struct RegexMatchCaptureGenerator : IteratorProtocol {
    public var items: ArraySlice<String>
    mutating public func next() -> String? {
        if items.isEmpty { return nil }
        let ret = items[items.startIndex]
        items = items[1..<items.count]
        return ret
    }
}

public struct RegexMatchResult  {
    public var items: Array<String>
    public func generate() -> RegexMatchCaptureGenerator {
        return RegexMatchCaptureGenerator(items: items[0..<items.count])
    }
    public var boolValue: Bool {
        return items.count > 0
    }
    public subscript (i: Int) -> String {
        return items[i]
    }
}
