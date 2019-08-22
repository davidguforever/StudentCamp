//
//  Optional+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.


import Foundation


public extension Optional {
    /// Gets the boolean value of an optional。 For all .None or nil values return false. Otherwise return true
    public var boolValue: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            if let booleanable = wrapped as? Bool {
                return booleanable
            }
            return true
        }
    }
}

// Since all optionals are actual enum values in Swift, we can easily
// extend them for certain types, to add our own convenience APIs
public extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        switch self {
        case let string?:
            return string.isEmpty
        case nil:
            return true
        }
    }
}

// Since strings are now Collections in Swift 4, you can even
// add this property to all optional collections:
//extension Optional where Wrapped: Collection {
//    var isNilOrEmpty: Bool {
//        switch self {
//        case let collection?:
//            return collection.isEmpty
//        case nil:
//            return true
//        }
//    }
//}



/// 文本包含内容
public protocol TextContaining {
    var isEmpty: Bool { get}
}

extension String: TextContaining { }


public extension Optional where Wrapped: TextContaining {
    /// 是否为空
    public var isEmpty: Bool {
        switch self {
        case let .some(value):
            return value.isEmpty
        case .none:
            return true
        }
    }
}

public extension String {
    // MARK: - Empty

    /// 是否为空 `Optional.isEmpty`
    ///
    ///         if "" {
    ///             print("yes")
    ///             // this code will not be executed
    ///         } else {
    ///             print("no")
    ///             // this code will be executed
    ///         }
    public var boolValue: Bool {
        return !self.isEmpty
    }
}


public extension Optional {

    /// 是否有值 `Optional.ifSome {}`
    ///
    ///       struct Person {
    ///           let name: String
    ///       }
    ///
    ///         var p: Person? = Person(name: "Joe")
    ///         p.ifSome { print($0) }.ifNone { print("none") } // prints Person
    ///
    ///         p = nil
    ///         p.ifSome { print($0) }.ifNone { print("none") } // prints none
    ///
    /// - Parameter handler: true to handle samething
    /// - Returns: Optional
    @discardableResult
    public func ifSome(_ handler: (Wrapped) -> Void) -> Optional {
        switch self {
        case .some(let wrapped): handler(wrapped); return self
        case .none: return self
        }
    }
    
    /// 是否为空
    ///
    /// - Parameter handler: true to handle samething
    /// - Returns: Optional
    @discardableResult
    public func ifNone(_ handler: () -> Void) -> Optional {
        switch self {
        case .some: return self
        case .none: handler(); return self
        }
    }
}


infix operator ???: NilCoalescingPrecedence

/// Optionals and String Interpolation
///
///         var someValue: Int? = 5
///         print("The value is \(someValue ??? "unknown")")
///         // → "The value is 5"
///         someValue = nil
///         print("The value is \(someValue ??? "unknown")")
///         // → "The value is unknown"
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    return optional.map { String(describing: $0) } ?? defaultValue()
}

