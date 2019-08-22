//  UISwitch+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UISwitch {
    
    ///切换开关 (toggles Switch)
    public func toggle() {
        self.setOn(!self.isOn, animated: true)
    }
}
