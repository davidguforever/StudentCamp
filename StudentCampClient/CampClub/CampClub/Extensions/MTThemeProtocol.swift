//
//  MTThemeProtocol.swift
//  CampClub
//
//  Created by HP on 2019/8/29.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation
import UIKit

protocol MTThemeProtocol {
    func getMainColor()->UIColor
    func getButtonColor() -> UIColor
    
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

    
}
struct MTThemeBoy :MTThemeProtocol{

    
    func getMainColor()->UIColor {
        return UIColor(red:0.17, green:0.34, blue:0.60, alpha:1.00)
    }
    
    func getButtonColor() -> UIColor {
        return UIColor.yellow
    }
    
}
struct MTThemeGirl :MTThemeProtocol{
    
    
    func getMainColor()->UIColor {
        return UIColor(red:0.17, green:0.34, blue:0.60, alpha:1.00)
    }
    
    func getButtonColor() -> UIColor {
        return UIColor.green
    }
    
}
//全体颜色的配置
var MTTheme:MTThemeProtocol = MTThemeBoy();
