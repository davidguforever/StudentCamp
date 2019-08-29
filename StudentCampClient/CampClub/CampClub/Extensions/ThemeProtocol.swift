//
//  ThemeProtocol.swift
//  CampClub
//
//  Created by HP on 2019/8/29.
//  Copyright © 2019 Mantis group. All rights reserved.
//

// Protocols.swift
import UIKit
let kUpdateTheme = "kUpdateTheme"
protocol ThemeProtocol {
}

extension  ThemeProtocol where Self: UIView {
    func addThemeObserver() {
        print("addViewThemeObserver")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
    func removeThemeObserver() {
        print("removeViewThemeObserver")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
}

extension ThemeProtocol where Self: UIViewController {
    func addThemeObserver() {
        print("addViewControllerThemeObserver")
        NotificationCenter.default.addObserver(self, selector: #selector(updateTheme), name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
    func removeThemeObserver() {
        print("removeViewControllerThemeObserver")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
}

extension UIView {
    @objc func updateTheme() {
        print("update view theme")
    }
}

extension UIViewController {
    @objc func updateTheme() {
        print("update view controller theme")
    }
}
