//
//  UIColor+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit


public extension UIColor {
    
    /// 平均颜色值 (inverse color)
    public var mt_inverseColor: UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red:1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
    
    public var mt_binaryColor: UIColor {
        
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        
        return white > 0.92 ? UIColor.blue : UIColor.white
    }
    
    
    /// init method with RGB values from 0 to 255, instead of 0 to 1
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// 初始化 hex: 0xf3832d3
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
        let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
        let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    
    /// 初始化
    ///
    /// - parameter hexString: 16进制字符串 #223442 0x435353
    /// - alpha: 透明度
    /// - return: 颜色
    public convenience init?(_ hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            self.init(hex: hex, alpha: alpha)
        } else {
            return nil
        }
    }
    
    
    /// conveniense init
    ///
    /// - Parameter hexStr: 16进制字符串   如：#aabbcc
    public convenience init(_ hexStr: String) {
        var hex = hexStr.hasPrefix("#")
            ? String(hexStr.dropFirst())
            : hexStr
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }
    
    /// init method from Gray value
    public convenience init(gray: CGFloat, alpha: CGFloat = 1) {
        self.init(red: gray/255, green: gray/255, blue: gray/255, alpha: alpha)
    }
    
    /// 红色
    public var redComponent: CGFloat {
        var r: CGFloat = 0
        getRed(&r, green: nil, blue: nil, alpha: nil)
        return r
    }
    
    /// 绿色
    public var greenComponent: CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    
    /// 蓝色
    public var blueComponent: CGFloat {
        var b: CGFloat = 0
        getRed(nil, green: nil, blue: &b, alpha: nil)
        return b
    }
    
    /// 透明度
    public var alpha: CGFloat {
        var a: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    
    /// 随机一个颜色
    ///
    ///   drand48() （0-1）随机
    /// - Parameter randomAlpha:  随机透明值
    /// - Returns: 颜色
    public static func randomColor(_ randomAlpha: Bool = false) -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: randomAlpha ? CGFloat(drand48()) : 1)
    }
    
}

public extension UIColor {
    /// Luminosity of the color on scale of 0 to 1.
    /// Value is subjective.
    public var luminosity: CGFloat {
        
        let components = cgColor.components
        return 0.2126 * components![0]
            + 0.7152 * components![1]
            + 0.0722 * components![2]
    }
    
    /// isDark
    ///
    /// ```
    ///  label.textColor = color.isDark ? UIColor.white : UIColor.darkGray
    /// ```
    public var isDark: Bool {
        return luminosity < 0.5
    }
    
    /// isBlackOrWhite
    public var isBlackOrWhite: Bool {
        let RGB = cgColor.components!
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    
    /// isBlack
    public var isBlack: Bool {
        let RGB = cgColor.components!
        return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
    }
    /// isWhite
    public var isWhite: Bool {
        let RGB = cgColor.components!
        return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
    }


    /// 获取饱和度最低的颜色
    ///
    /// - Parameter minSaturation: 饱和度
    /// - Returns: 结果颜色
    public func colorWithMinimumSaturation(_ minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }


    public func color(minSaturation: CGFloat) -> UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return saturation < minSaturation
            ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
            : self
    }
    
    
    /// 设置透明
    ///
    /// - Parameter value: 透明值
    /// - Returns: color
    public func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }
    
    
    /// 与传入颜色是否有区别
    ///
    /// - Parameter color: 指定颜色
    /// - Returns: 结果 true or false
    public func isDistinct(from color: UIColor) -> Bool {
        let bg = rgbComponents
        let fg = color.rgbComponents
        let threshold: CGFloat = 0.25
        var result = false
        
        if abs(bg.0 - fg.0) > threshold || abs(bg.1 - fg.1) > threshold || abs(bg.2 - fg.2) > threshold {
            if abs(bg.0 - bg.1) < 0.03 && abs(bg.0 - bg.2) < 0.03 {
                if abs(fg.0 - fg.1) < 0.03 && abs(fg.0 - fg.2) < 0.03 {
                    result = false
                }
            }
            result = true
        }
        
        return result
    }
    
    /// 与传入颜色是否对比
    ///
    /// - Parameter color: 指定颜色
    /// - Returns: 结果  true or false
    public func isContrasting(with color: UIColor) -> Bool {
        let bg = rgbComponents
        let fg = color.rgbComponents
        
        let bgLum = 0.2126 * bg.0 + 0.7152 * bg.1 + 0.0722 * bg.2
        let fgLum = 0.2126 * fg.0 + 0.7152 * fg.1 + 0.0722 * fg.2
        let contrast = bgLum > fgLum
            ? (bgLum + 0.05) / (fgLum + 0.05)
            : (fgLum + 0.05) / (bgLum + 0.05)
        
        return 1.6 < contrast
    }
    
    /// get r g b a
    public var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
    
    /// get hue, saturation, brightness and alpha components from UIColor**
    public var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue, saturation, brightness, alpha)
    }
    
    /// get hex String. such as: #eeaacc
    var hex: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        r = max(r, 0)
        g = max(g, 0)
        b = max(b, 0)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
        //return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    
    /// get RGBA hex String. such as: #eeaacc33
    var hexRGBa: String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        r = max(r, 0)
        g = max(g, 0)
        b = max(b, 0)
        a = max(a, 0)
        return String(format: "#%02x%02x%02x%02x", Int(r * 255), Int(g * 255),Int(b * 255),Int(a * 255) )
    }
    
}


// MARK: - Gradient
public extension Array where Element : UIColor {
    
    /// 根据颜色数组获取渐变Layer
    ///
    /// - Parameter transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)?
    /// - Returns: CAGradientLayer
    public func gradient(_ transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil) -> CAGradientLayer {
        var gradient = CAGradientLayer()
        gradient.colors = self.map { $0.cgColor }
        
        if let transform = transform {
            gradient = transform(&gradient)
        }
        
        return gradient
    }
}

// MARK: - Blending
public extension UIColor {
    
    //// **adds hue, saturation, and brightness to the HSB components of this color (self)*/
    public func add(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldHue, oldSat, oldBright, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)
        
        // make sure new values doesn't overflow
        var newHue = oldHue + hue
        while newHue < 0.0 { newHue += 1.0 }
        while newHue > 1.0 { newHue -= 1.0 }
        
        let newBright: CGFloat = max(min(oldBright + brightness, 1.0), 0)
        let newSat: CGFloat = max(min(oldSat + saturation, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
        
        return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: newAlpha)
    }
    
    /// **adds red, green, and blue to the RGB components of this color (self)*/
    public func add(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        var (oldRed, oldGreen, oldBlue, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
        // make sure new values doesn't overflow
        let newRed: CGFloat = max(min(oldRed + red, 1.0), 0)
        let newGreen: CGFloat = max(min(oldGreen + green, 1.0), 0)
        let newBlue: CGFloat = max(min(oldBlue + blue, 1.0), 0)
        let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
    
    
    /// 添加颜色
    ///
    /// - Parameter color: color
    /// - Returns: new color
    public func add(hsb color: UIColor) -> UIColor {
        var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return self.add(hue: h, saturation: s, brightness: b, alpha: 0)
    }
    /// 添加颜色
    ///
    /// - Parameter color: color
    /// - Returns: new color
    public func add(rgb color: UIColor) -> UIColor {
        return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0)
    }
    /// 添加颜色
    ///
    /// - Parameter color: color
    /// - Returns: new color
    public func add(hsba color: UIColor) -> UIColor {
        var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return self.add(hue: h, saturation: s, brightness: b, alpha: a)
    }
    
    //// adds the rgb components of two colors
    public func add(rgba color: UIColor) -> UIColor {
        return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alpha)
    }
    
    
    /// 获取一种很好的颜色，与另一种有趣的颜色混合，并把它变成漂亮的第三种颜色。(Take a nice color, mix it with another fun color, and turn it into a pretty third color.)
    ///
    /// - Parameters:
    ///   - first: first color
    ///   - second: second color
    ///   - ratio: 比率  ratio
    convenience init(blending first: UIColor, with second: UIColor, ratio: CGFloat) {
        func blendComponent(from firstValue: CGFloat, to secondValue: CGFloat) -> CGFloat {
            let diff = secondValue - firstValue
            return diff * ratio + firstValue
        }
        
        let firstCIColor = CIColor(color: first)
        let secondCIColor = CIColor(color: second)
        
        let red = blendComponent(from: firstCIColor.red, to: secondCIColor.red)
        let green = blendComponent(from: firstCIColor.green, to: secondCIColor.green)
        let blue = blendComponent(from: firstCIColor.blue, to: secondCIColor.blue)
        let alpha = blendComponent(from: firstCIColor.alpha, to: secondCIColor.alpha)
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


