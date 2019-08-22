//
//  System+Ext.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/5/3.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import UIKit


enum MTFont: String {
    
    case merriweather = "Merriweather-Regular"
    //case SourceSansPro = "SourceSansPro-Regular"
    
    func font(_ size: CGFloat = 16.0) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}

// MARK: - Font Loading
let loadCustomFonts: () = {
    let loadedFontMontserrat = UIFont.loadFont(MTFont.merriweather.rawValue)
    //let loadedFontSourceSansPro = UIFont.loadFont(Font.SourceSansPro.rawValue)
    if loadedFontMontserrat {
        print("================= LOADED FONTS")
    }
}()

extension UIFont {
    
    static func loadFont(_ name: String) -> Bool {
        let bundle = Bundle.main
        guard let fontPath = bundle.path(forResource: name, ofType: "ttf"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath)),
            let provider = CGDataProvider(data: data as CFData),
            let font = CGFont(provider)
            else {
                return false
        }
        
        var error: Unmanaged<CFError>?
        
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        if !success {
            print("Error loading font. Font is possibly already registered.")
            return false
        }
        
        return true
    }
}


extension Date {
    var yyyyMMdd: String {
        return self.toString("yyyy-MM-dd")
    }
}


extension UIImage {
    
    /// UIImage根据高宽比缩放到高度
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    public func scaled(toHeight: CGFloat, opaque: Bool = false, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        if toHeight < size.height {
            let scale = toHeight / size.height
            let newWidth = size.width * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, scale)
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        } else {
            return self
        }
    }
    
    /// UIImage根据高宽比缩放到宽度
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    public func scaled(toWidth: CGFloat, opaque: Bool = false, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        if toWidth < size.width {
            let scale = toWidth / size.width
            let newHeight = size.height * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, scale)
            draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        else {
            return self
        }
    }
    
}


extension UIImage {
    // MARK: - UIImage+Resize
    
    /// 质量压缩  循环
    ///
    /// - Parameter expectedSize: 最大尺寸，压缩后不超过此大小 (单位: Byte, 2M = 2 * 1024 * 1024)
    /// - Returns: IMAGE
    func compressTo(_ expectedSize: Int) -> UIImage {
        
        var needCompress:Bool = true
        var imgData: Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < expectedSize {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < expectedSize) {
                return UIImage(data: data) ?? self
            }
        }
        return self
    }
    

}

// MARK: - Methods
public extension UINavigationController {
    

    /// 移除中间所有界面，保留首尾2个
    ///
    /// - Parameter item: viewcontroller
    public func removeMiddles() {
        var vcs = self.viewControllers
        if vcs.count > 2 {
            self.viewControllers = [vcs[0], vcs.last! ]
        }
    }
    
    /// 移除指定位置界面
    ///
    /// - Parameter item: viewcontroller
    public func remove(_ index: Int) {
        var vcs = viewControllers
        if vcs.count > index && index > -1 {
            vcs.remove(at: index)
        }
        viewControllers = vcs
    }
}


public extension UILabel {
    @objc public func pushTransition(_ duration: CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        self.layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.push))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionType(_ input: CATransitionType) -> String {
	return input.rawValue
}
