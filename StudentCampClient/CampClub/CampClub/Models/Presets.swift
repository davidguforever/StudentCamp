//
//  Presets.swift
//  HouseShop
//
//  Created by Luochun on 2018/9/14.
//  Copyright © 2018 Mantis Group. All rights reserved.
//

import Foundation

import MTCobwebs
import SwiftEntryKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}
struct Presets {
    // Cumputed for the sake of reusability
    static var bottomAlertAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color:  UIColor(white: 100.0/255.0, alpha: 0.3))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 10)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.7, spring: .init(damping: 1, initialVelocity: 0)),
                                             scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.2))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.verticalOffset = 10
        attributes.positionConstraints.size = .init(width: .offset(value: 20), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        attributes.statusBar = .dark
        return attributes
    }
    
    static var verfyPwdAttributes: EKAttributes {
        var attributes = EKAttributes.float
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom,  spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .absorbTouches
        
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3))
        
        attributes.border = .value(color: UIColor(white: 0.6, alpha: 1), width: 1)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 8)
        attributes.statusBar = .dark
        
        //attributes.positionConstraints.verticalOffset = -100
        attributes.positionConstraints.size = .init(width: .constant(value: 280), height: .constant(value: 180))
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 40, screenEdgeResistance: 0))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        return attributes
    }
    
    static var centerAlertAttributes: EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled   //.enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.screenBackground = .color(color: UIColor.clear)
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 1, initialVelocity: 0)), scale: .init(from: 0.6, to: 1, duration: 0.5), fade: .init(from: 0.8, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(scale: .init(from: 1, to: 0.7, duration: 0.3), fade: .init(from: 1, to: 0, duration: 0.3))
        attributes.displayDuration = .infinity
        //attributes.border = .value(color: .black, width: 0.5)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.2, radius: 5))
        attributes.statusBar = .dark
        attributes.positionConstraints.size = .init(width: .offset(value: 25), height: .constant(value: 180))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        return attributes
    }
    
    // Cumputed for the sake of reusability
    static var bottomShareAttributes: EKAttributes {
        var attributes = EKAttributes.bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color:  UIColor(white: 100.0/255.0, alpha: 0.3))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 8))
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.roundCorners = .all(radius: 0)
        attributes.entranceAnimation = .init(translate: .init(duration: 0.7, spring: .init(damping: 1, initialVelocity: 0)),
                                             scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.2))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.2)))
        attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
        attributes.positionConstraints.verticalOffset = 0
        //attributes.positionConstraints.size = .init(width: .constant(value: 280), height: .constant(value: 180))
        attributes.positionConstraints.size = .init(width: .offset(value: 0), height: .constant(value: 170))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        attributes.statusBar = .dark
        return attributes
    }

}

extension UIViewController {
    
    /// 显示推送消息
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - desc: 描述
    func showPopupMessage(title: String, desc: String) {
        MTSystemSound.playSystemSound(audioID: .receivedMessage)
        let image = UIImage(named: "push_msg")
        let attributes = Presets.bottomAlertAttributes
        
        //showPopupMessage(attributes: attributes, title: title, titleColor: MTColor.title222, description: description, descriptionColor: MTColor.des999, buttonTitleColor: .white, buttonBackgroundColor: MTColor.mainX, image: image)
        let titleColor = MTColor.title222
        let descriptionColor = MTColor.des666
        let buttonTitleColor = UIColor.white
        let buttonBackgroundColor = MTColor.mainX
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
            themeImage?.position = .topToTop(offset: 20)
        }
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 20), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: UIFont.systemFont(ofSize: 14), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "确定", style: .init(font: UIFont.systemFont(ofSize: 15), color: buttonTitleColor)), backgroundColor: buttonBackgroundColor, highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    
    func showPopupMessage(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, buttonTitleColor: UIColor, buttonBackgroundColor: UIColor, image: UIImage? = nil) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
            themeImage?.position = .topToTop(offset: 20)
        }
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 20), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: UIFont.systemFont(ofSize: 14), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "确定", style: .init(font: UIFont.systemFont(ofSize: 14), color: buttonTitleColor)), backgroundColor: buttonBackgroundColor, highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
}
