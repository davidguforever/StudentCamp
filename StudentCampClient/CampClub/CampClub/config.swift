//
//  config.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/3/12.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import  UIKit
import MTCobwebs


    /// API
//let BaseUrl = "http://39.100.87.191:8080/"
let BaseUrl = "http://127.0.0.1:8080/"
public typealias JSONMap = [String: Any]

struct AppConfig {
    static let closeImage = CAShapeLayer.closeShape(edgeLength: 15, fillColor: MTTheme.getMainColor()).toImage()
    static let backImage = CAShapeLayer.backShape(edgeLength: 16).toImage()
}


extension NSNotification.Name {
    public static var indexNeedRefresh: NSNotification.Name = NSNotification.Name("MTIndexNeedRefresh")
    
    public static var userDidLogin: NSNotification.Name = NSNotification.Name("MTUserDidLoginNotification")
    public static var userDidLogOut: NSNotification.Name = NSNotification.Name("MTUserDidLogOutNotification")
}







struct pingFang_SC {
    static func bold(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    static func medium(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Medium", size: size)!
    }
    static func regular(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Regular", size: size)!
    }
    static func light(_ size: CGFloat = 15.0) -> UIFont {
        return UIFont(name: "PingFang-SC-Light", size: size)!
    }
    
}
