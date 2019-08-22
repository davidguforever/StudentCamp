
//
//  NSDate+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation

// MARK: - Properties
public extension Date {
    
    /// User’s current calendar.
    public var calendar: Calendar {
        return Calendar.current
    }
    
    /// Era.
    ///
    ///        Date().era -> 1
    ///
    public var era: Int {
        return Calendar.current.component(.era, from: self)
    }
    
    /// Quarter.
    ///
    ///        Date().quarter -> 3 // date in third quarter of the year.
    ///
    public var quarter: Int {
        let month = Double(Calendar.current.component(.month, from: self))
        let numberOfMonths = Double(Calendar.current.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month/numberOfMonthsInQuarter))
    }
    
    /// Week of year.
    ///
    ///        Date().weekOfYear -> 2 // second week in the year.
    ///
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    /// Week of month.
    ///
    ///        Date().weekOfMonth -> 3 // date is in third week of the month.
    ///
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    /// Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    public var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    public var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = Calendar.current.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    public var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Weekday.
    ///
    ///     Date().weekday -> 5 // fifth day in the current week.
    ///
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    public var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    public var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    public var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Nanoseconds.
    ///
    ///     Date().nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    public var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentNanoseconds = Calendar.current.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds
            
            if let date = Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Milliseconds.
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    public var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(ns) else { return }
            
            if let date = Calendar.current.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }
    
    /// Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    public var isInFuture: Bool {
        return self > Date()
    }
    
    /// Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    public var isInPast: Bool {
        return self < Date()
    }
    
    /// Check if date is within today.
    ///
    ///     Date().isInToday -> true
    ///
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is within yesterday.
    ///
    ///     Date().isInYesterday -> false
    ///
    public var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is within tomorrow.
    ///
    ///     Date().isInTomorrow -> false
    ///
    public var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is within a weekend period.
    public var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// 是否工作日 Check if date is within a weekday period.
    public var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// 是否在本周内 Check if date is within the current week.
    public var isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// 是否在本月内 Check if date is within the current month.
    public var isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// 是否本年内 Check if date is within the current year.
    public var isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    /// Check if date is within a weekday period.
    public var isInWeekday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    

    /// ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    public var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    /// Nearest five minutes to date.
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    public var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    public var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    public var nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    public var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    public var nearestHour: Date {
        let min = Calendar.current.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = Calendar.current.date(from: Calendar.current.dateComponents(components, from: self))!
        
        if min < 30 {
            return date
        }
        return Calendar.current.date(byAdding: .hour, value: 1, to: date)!
    }
    
    /// Yesterday date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    public var yesterday: Date {
        return addingTimeInterval(-86400.0)
    }
    
    /// Tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    public var tomorrow: Date {
        return addingTimeInterval(86400.0)
    }
    

    
    /// Time zone used currently by system.
    ///
    ///        Date().timeZone -> Europe/Istanbul (current)
    ///
    public var timeZone: TimeZone {
        return Calendar.current.timeZone
    }
    
    /// UNIX timestamp from date.
    ///
    ///        Date().unixTimestamp -> 1484233862.826291
    ///
    public var unixTimestamp: Double {
        return timeIntervalSince1970
    }
    
    
    
}

public extension Date {
    
    /// 本周开始时间
    public func firstDateInThisWeek() -> Date {
        var beginningOfWeek: NSDate? = self as NSDate?
        let calendar = Calendar.current
        (calendar as NSCalendar).range(of: .weekOfYear, start: &beginningOfWeek, interval: nil, for: self)
        
        return beginningOfWeek! as Date
    }
    

    /// ISO08601日期格式 转换为 Date
    ///
    /// - Parameter dateString: ISO08601日期格式字符串
    /// - Returns: 日期 （如果入参非指定格式，即返回 当前日期） yyyy-MM-dd'T'HH:mm:ssZ
    public static func dateWithISO08601String(_ dateString: String?) -> Date {
        if let dateString = dateString {
            var dateString = dateString
            
            if dateString.hasSuffix("Z") {
                dateString = String(dateString.dropLast()) + "-0000"
            }
            
            return dateFromString(dateString, withFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
        }
        
        return Date()
    }
    

    
    /// 从字符串返回格式化日期
    ///
    /// - Parameters:
    ///   - dateString: 时间字符串
    ///   - dateFormat: 日期格式
    /// - Returns: 转换的日期
    public static func dateFromString(_ dateString: String, withFormat dateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return Date()
        }
    }
    
    //获取周
    public static func getWeekDay(year: Int, month: Int, day: Int) -> Int {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date:Date? = dateFormatter.date(from: String(format:"%04d/%02d/%02d",year,month,day))
        if date != nil {
            let calendar = NSCalendar.current
            let dateComp = (calendar as NSCalendar).components(.weekday, from: date!)
            return dateComp.weekday!
        }
        return 0
    }
}

public extension Date {

    /// 距离现在有多久 (多久以前)
    public func timeAgoSinceNow() -> String {
        return timeAgoSince(self, numericDates: true)
    }
    

    /// 根据指定时间算出多久 (如：1年前，1月前……)
    ///
    /// - Parameters:
    ///   - date: 比较时间
    ///   - numericDates: 是否简单化 (1年前 = 去年)
    /// - Returns:  结果字符串
    public func timeAgoSince(_ date:Date, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let now = Date()
        let earliest = now < date ? now: date
        let latest = (earliest == now) ? date : now
        let components = (calendar as NSCalendar).components([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: earliest, to: latest, options: [])
        
        if (components.year! >= 2) {
            return "\(components.year!)年前"
        } else if (components.year! >= 1) {
            if (numericDates) {
                return "1年前"
            } else {
                return "去年"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)月前"
        } else if (components.month! >= 1) {
            if (numericDates) {
                return "1月前"
            } else {
                return "上月"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)周前"
        } else if (components.weekOfYear! >= 1) {
            if (numericDates) {
                return "1周前"
            } else {
                return "上周"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)天前"
        } else if (components.day! >= 1) {
            if (numericDates) {
                return "1天前"
            } else {
                return "昨天"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)小时前"
        } else if (components.hour! >= 1) {
            if (numericDates) {
                return "1小时前"
            } else {
                return "1小时前"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)分钟前"
        } else if (components.minute! >= 1) {
            if (numericDates) {
                return "1分钟前"
            } else {
                return "1分钟前"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)秒前"
        } else {
            return "现在"
        }
    }

    /// 根据指定时间算出多久后 （如：3天08:32:10）
    ///
    /// - Parameter date: 比较时间
    /// - Returns: 结果字符串
    public func timeAfterTo(_ date:Date) -> String {
        let calendar = NSCalendar.current
        let now = Date()
        let earliest = now < date ? now: date
        let latest = (earliest == now) ? date : now
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: earliest, to: latest, options: [])
        
        var durring = ""
        if (components.day! >= 1) {
            durring += "\(components.day!)天 "
        }
        durring += String(format: "%.2d", components.hour!) + ":" + String(format: "%.2d", components.minute!) + ":" + String(format: "%.2d", components.second!)
        return durring
    }


    /// 转为字符串  格式：yyyy-MM-dd HH:mm:ss
    public func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
 
    /// 转为字符串
    ///
    /// - Parameter format: 格式化 如 :yyyyMMddHHmmssSSSZZ
    /// - Returns: String
    public func toString(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
}


public extension Date {
    
    /// 当前年第一天
    ///
    /// - Returns: Date
    public func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    
    /// 当前年最后一天
    ///
    /// - Returns: Date
    public func endOfYear() -> Date {
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: self.startOfYear())!
    }
    
    /// 当前月第一天
    ///
    /// - Returns: Date
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// 当前周第一天
    ///
    /// - Returns: Date
    public func startOfWeekDay() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .weekday], from: Calendar.current.startOfDay(for: self)))!
    }
    
    
    public func startOfWeek(weekday: Int?) -> Date {
        var cal = Calendar.current
        var component = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        component.to12am()
        cal.firstWeekday = weekday ?? 1
        return cal.date(from: component)!
    }
    
    /// 周最后一天
    /// weekday   1 当天
    /// - Returns: Date
    public func endOfWeek(weekday: Int = 1) -> Date {
        let cal = Calendar.current
        var component = DateComponents()
        component.weekOfYear = 1
        component.day = -1
        component.to12pm()
        return cal.date(byAdding: component, to: startOfWeek(weekday: weekday))!
    }
    
    /// 当前月最后一天
    ///
    /// - Returns: Date
    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    public func zeroOfDay() -> Date {
        let calendar = Calendar.current
        var comp  = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self)
        comp.hour = 0
        comp.minute = 0
        comp.second = 0
        let ts =  calendar.date(from: comp)?.timeIntervalSince1970
        return Date(timeIntervalSince1970:ts!)
        
    }
    
    /// 天最后时间
    /// weekday   1 当天
    /// - Returns: Date
    public func endOfDay() -> Date {
        let cal = Calendar.current
        var component = DateComponents()
        component.hour = 23
        component.minute = 59
        component.second = 59
        return cal.date(byAdding: component, to: self)!
    }
    
    
    ///  Date by adding multiples of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     let date2 = date.adding(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     let date3 = date.adding(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     let date4 = date.adding(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     let date5 = date.adding(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    public func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    /// Add calendar component to date.
    ///
    ///     var date = Date() // "Jan 12, 2017, 7:07 PM"
    ///     date.add(.minute, value: -10) // "Jan 12, 2017, 6:57 PM"
    ///     date.add(.day, value: 4) // "Jan 16, 2017, 7:07 PM"
    ///     date.add(.month, value: 2) // "Mar 12, 2017, 7:07 PM"
    ///     date.add(.year, value: 13) // "Jan 12, 2030, 7:07 PM"
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    public mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }
    
    /// Data at the beginning of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    public func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))
            
        case .minute:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self))
            
        case .hour:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))
            
        case .day:
            return Calendar.current.startOfDay(for: self)
            
        case .weekOfYear, .weekOfMonth:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
            
        case .month:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: self))
            
        case .year:
            return Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: self))
            
        default:
            return nil
        }
    }
    
    /// Date at the end of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    public func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date
            
        case .minute:
            var date = adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .hour:
            var date = adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .day:
            var date = adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.add(.second, value: -1)
            return date
            
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
            
        case .month:
            var date = adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .year:
            var date = adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        default:
            return nil
        }
    }

}


internal extension DateComponents {
    mutating func to12am() {
        self.hour = 0
        self.minute = 0
        self.second = 0
    }
    
    mutating func to12pm() {
        self.hour = 23
        self.minute = 59
        self.second = 59
    }
}

public extension Date {
    
    // MARK: - Dates comparison
    
    /// 是否在指定日期后
    public func isGreaterThanDate(dateToCompare: Date) -> Bool {
        
        return self.compare(dateToCompare) == .orderedDescending
    }
    
    /// 是否在指定日期前
    public func isLessThanDate(dateToCompare: Date) -> Bool {
        
        return self.compare(dateToCompare) == .orderedAscending
    }
    
    /// 是否与指定日期相同
    public func equalToDate(dateToCompare: Date) -> Bool {
        
        return self.compare(dateToCompare) == .orderedSame
    }
    
    /// check if a date is between two other dates
    ///
    /// - Parameters:
    ///   - startDate: start date to compare self to.
    ///   - endDate: endDate date to compare self to.
    ///   - includeBounds: true if the start and end date should be included (default is false)
    /// - Returns: true if the date is between the two given dates.
    public func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * self.compare(endDate).rawValue >= 0
        } else {
            return startDate.compare(self).rawValue * self.compare(endDate).rawValue > 0
        }
    }
    
    
    /// check if a date is a number of date components of another date
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date
    public func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = Calendar.current.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return abs(componentValue) <= value
    }
    
    /// Random date between two dates.
    ///
    ///     Date.random()
    ///     Date.random(from: Date())
    ///     Date.random(upTo: Date())
    ///     Date.random(from: Date(), upTo: Date())
    ///
    /// - Parameters:
    ///   - fromDate: minimum date (default is Date.distantPast)
    ///   - toDate: maximum date (default is Date.distantFuture)
    /// - Returns: random date between two dates.
    public static func random(from fromDate: Date = Date.distantPast, upTo toDate: Date = Date.distantFuture) -> Date {
        guard fromDate != toDate else {
            return fromDate
        }
        
        let diff = llabs(Int64(toDate.timeIntervalSinceReferenceDate - fromDate.timeIntervalSinceReferenceDate))
        var randomValue: Int64 = 0
        arc4random_buf(&randomValue, MemoryLayout<Int64>.size)
        randomValue = llabs(randomValue%diff)
        
        let startReferenceDate = toDate > fromDate ? fromDate : toDate
        return startReferenceDate.addingTimeInterval(TimeInterval(randomValue))
    }
    
    /// Returns a random date within the specified range.
    ///
    /// - Parameter range: The range in which to create a random date. `range` must not be empty.
    /// - Returns: A random date within the bounds of `range`.
    public static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound.timeIntervalSinceReferenceDate))
    }
    
    /// Returns a random date within the specified range.
    ///
    /// - Parameter range: The range in which to create a random date.
    /// - Returns: A random date within the bounds of `range`.
    public static func random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate...range.upperBound.timeIntervalSinceReferenceDate))
    }
    
    /// Returns a random date within the specified range, using the given generator as a source for randomness.
    ///
    /// - Parameters:
    ///   - range: The range in which to create a random date. `range` must not be empty.
    ///   - generator: The random number generator to use when creating the new random date.
    /// - Returns: A random date within the bounds of `range`.
    public static func random<T>(in range: Range<Date>, using generator: inout T) -> Date where T: RandomNumberGenerator {
        return Date(timeIntervalSinceReferenceDate:
            TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate..<range.upperBound.timeIntervalSinceReferenceDate,
                                using: &generator))
    }

    
    /// Create date object from Int literal
    ///
    ///     let date = Date(integerLiteral: 2017_12_25) // "2017-12-25 00:00:00 +0000"
    /// - Parameter value: Int value, e.g. 20171225, or 2017_12_25 etc.
    public init?(integerLiteral value: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        guard let date = formatter.date(from: String(value)) else { return nil }
        self = date
    }
    
}

