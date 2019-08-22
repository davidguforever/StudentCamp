//
//  Calendar+MTExt.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import Foundation

// MARK: - Methods
public extension Calendar {
    
    /// 返回指定日期当月天数  Return the number of days in the month for a specified 'Date'.
    ///
    ///        let date = Date() // "Jan 12, 2018, 17:28 PM"
    ///        Calendar.current.numberOfDaysInMonth(for: date) -> 31
    ///
    /// - Parameter date: the date form which the number of days in month is calculated.
    /// - Returns: The number of days in the month of 'Date'.
    public func numberOfDaysInMonth(for date: Date) -> Int {
        return range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
}
