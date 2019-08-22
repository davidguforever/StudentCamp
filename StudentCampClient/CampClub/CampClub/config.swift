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
    static let closeImage = CAShapeLayer.closeShape(edgeLength: 15, fillColor: MTColor.main).toImage()
    static let backImage = CAShapeLayer.backShape(edgeLength: 16).toImage()
}


extension NSNotification.Name {
    public static var indexNeedRefresh: NSNotification.Name = NSNotification.Name("MTIndexNeedRefresh")
    
    public static var userDidLogin: NSNotification.Name = NSNotification.Name("MTUserDidLoginNotification")
    public static var userDidLogOut: NSNotification.Name = NSNotification.Name("MTUserDidLogOutNotification")
}



struct MTColor {
    static var main = UIColor(red:0.17, green:0.34, blue:0.60, alpha:1.00)
    static var mainX = UIColor(hex: 0xFF4F00)    //#FF4F00
    
    static var secondBlue = UIColor(red:0.15, green:0.53, blue:1.00, alpha:1.00) //蓝色

    static var pageback = UIColor.white
    
    static var title111 = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
    static var title222 = UIColor(hex: 0x222222)
    
    static var des666 = UIColor(hex: 0x666666)
    static var des999 = UIColor(hex: 0x999999)         //999999
    
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
