//
//  UITableView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UITableView {
    /// default table cell indentifier  return "Cell"
    public static var defaultCellIdentifier: String {
        return "Cell"
    }
    
    /// Register NIB to table view. NIB name and cell reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - nibName: Name of the NIB.
    ///   - cellIdentifier: Name of the reusable cell identifier.
    ///   - bundleIdentifier: Name of the bundle identifier if not local.
    public func registerNib(nibName: String, cellIdentifier: String = defaultCellIdentifier, bundleIdentifier: String? = nil) {
        self.register(UINib(nibName: nibName,
                               bundle: bundleIdentifier != nil ? Bundle(identifier: bundleIdentifier!) : nil),
                         forCellReuseIdentifier: cellIdentifier)
    }
    
    /// Register NIB to table view. NIB name and cell reuse identifier can match for convenience.
    ///
    /// - Parameters:
    ///   - cellClass: Name of the NIB.
    ///   - cellIdentifier: Name of the reusable cell identifier.
    ///   - bundleIdentifier: Name of the bundle identifier if not local.
    public func registerNib(cellClass: AnyClass, cellIdentifier: String = defaultCellIdentifier, bundleIdentifier: String? = nil) {
        let identifier = String.className(cellClass)
        self.register(UINib(nibName: identifier,
                            bundle: bundleIdentifier != nil ? Bundle(identifier: bundleIdentifier!) : nil),
                      forCellReuseIdentifier: cellIdentifier)
    }

    /// Gets the reusable cell with default identifier name.
    ///
    /// - Parameter indexPath: The index path of the cell from the table.
    public subscript(indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: UITableView.defaultCellIdentifier, for: indexPath)
    }
    
    /// Gets the reusable cell with the specified identifier name.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the cell from the table.
    ///   - identifier: Name of the reusable cell identifier.
    public subscript(indexPath: IndexPath, identifier: String) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

}


public extension UITableView {
    
    /// Index path of last row in tableView.
    public var indexPathForLastRow: IndexPath? {
        guard numberOfRows > 0 else {
            return nil
        }
        return IndexPath(row: numberOfRows - 1, section: lastSection)
    }
    
    /// Index of last section in tableView.
    public var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    /// Number of all rows in all sections of tableView.
    public var numberOfRows: Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
}


// MARK: - Methods
public extension UITableView {
    

    /// IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    public func indexPathForLastRow(in section: Int) -> IndexPath? {
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// Remove TableFooterView.
    public func removeTableFooterView() {
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    /// Remove TableHeaderView.
    public func removeTableHeaderView() {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    /// Scroll to bottom of TableView.
    ///
    /// - animated: set true to animate scroll (default is true).
    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// Scroll to top of TableView.
    ///
    /// - animated: set true to animate scroll (default is true).
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
