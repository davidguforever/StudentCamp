//
//  MTThemeProtocol.swift
//  CampClub
//
//  Created by HP on 2019/8/29.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation
import UIKit


extension UIImage{
    
    /// 更改图片颜色
    public func imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

protocol MTThemeProtocol {
    //主要的颜色
    func getMainColor()->UIColor
    func getButtonColor() -> UIColor
    func getFontColor()-> UIColor
    //历史遗留，不知道干什么的颜色
    func getPageBack()->UIColor
    func getTitleColor1() -> UIColor
    func getTitleColor2() -> UIColor
}
extension MTThemeProtocol{//一些默认实现和拓展（不需要改变的颜色）
    func getDarkGray()->UIColor{ //深灰
        return UIColor(hex: 0x666666)
    }
    func getLightGray()->UIColor{  //浅灰
        return UIColor(hex: 0x999999)
    }
    func getPageBack()->UIColor{
        return UIColor.white
    }
    func getTitleColor1() -> UIColor {
        return UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
    }
    func getTitleColor2() -> UIColor {
        return UIColor(hex: 0x222222)
    }
    func getFontColor()-> UIColor{
        return UIColor.red
    }
    
}
struct MTThemeBoy :MTThemeProtocol{

    
    func getMainColor()->UIColor {
        return UIColor(red:0.17, green:0.34, blue:0.60, alpha:1.00)
        //return UIColor.green
    }
    
    func getButtonColor() -> UIColor {
        return getMainColor()
    }
    func getFontColor() -> UIColor {
        return getButtonColor()
    }
    
}
struct MTThemeGirl :MTThemeProtocol{
    
    
    func getMainColor()->UIColor {
        return UIColor(hex:0xFFB6C1)
    }
    
    func getButtonColor() -> UIColor {
        return getMainColor()
    }
    func getFontColor() -> UIColor {
        return getMainColor()
    }
    
}
//全体颜色的配置
var MTTheme:MTThemeProtocol = MTThemeBoy();


class ThemeManager {
    //单例工具，直接可以Thememanager.defaults.xxx()
    static let defaults=ThemeManager()
    //一个保存本地配置的方法
    let userDefault = UserDefaults.standard
    
    func storeTheme(){
        userDefault.setValue(getThemeName(), forKey: "themeName")
        print("保存当前主题为:"+getThemeName())
    }
    func setTheme(_ themeName:String){
        switch themeName {
        case "boy":
            MTTheme=MTThemeBoy()
        case "girl":
            MTTheme=MTThemeGirl()
        default:
            MTTheme=MTThemeBoy()
        }
    }
    func getThemeName() -> String {
        switch  MTTheme {
        case is MTThemeBoy:
            return "boy"
        case is MTThemeGirl:
            return "girl"
        default:
            return "boy"
        }
    }
    
    
    
    func initTheme(){
        //如果本地有保存，就获取本地主题名并设置主题
        if let theme=userDefault.string(forKey: "themeName"){
            setTheme(theme)
        }else{
        //如果未保存就保存主题名
            storeTheme()
        }
        //通知所有view更新
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
    }
    func changetheme() {
        //获取主题名，并设为另一个主题
        let theme=getThemeName()
        switch theme {
        case "boy":
            MTTheme=MTThemeGirl()
            storeTheme()
        case "girl":
            MTTheme=MTThemeBoy()
            storeTheme()
        default:
            MTTheme=MTThemeBoy()
        }
        //通知所有view更新
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUpdateTheme), object: nil)
        
    }
    
}
