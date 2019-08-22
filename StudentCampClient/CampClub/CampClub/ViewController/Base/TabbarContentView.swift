//
//  TabbarContentView.swift
//
//  Created by Luochun on 2017/9/14.
//  Copyright © 2017年 Maintis. All rights reserved.
//

import Foundation
import UIKit

extension ESTabBarController {
    /// 创建Tab
    static func createTabbar() -> UIViewController {
        let tabBarController = ESTabBarController()
        tabBarController.delegate = AppDelegate.shared
        
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 1 {
                return false
            }
            return false
        }
//        tabBarController.didHijackHandler = {
//            [weak tabBarController] tabbarController, viewController, index in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            }
//        }
        
        let v1 = UIStoryboard.Scene.home
        let v2 = UIStoryboard.Scene.share
        let v3 = UIStoryboard.Scene.mine
        
        let n1 = MTNavigationController(rootViewController: v1)
        let n2 = MTNavigationController(rootViewController: v2)
        let n3 = MTNavigationController(rootViewController: v3)
        
        n1.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "营务", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_s"))
        n2.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "分享", image: #imageLiteral(resourceName: "cate"), selectedImage: #imageLiteral(resourceName: "cate_s"))
        n3.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "个人", image: #imageLiteral(resourceName: "mine"), selectedImage: #imageLiteral(resourceName: "mine_s"))
        
        //n1.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -10)
        tabBarController.viewControllers = [n1, n2, n3]
        //if let tabBar = tabBarController.tabBar as? ESTabBar {
            //tabBar.itemCustomPositioning = .fillIncludeSeparator
        //}
        tabBarController.tabBar.shadowImage = #imageLiteral(resourceName: "Transparent")
        //tabBarController.tabBar.backgroundImage = #imageLiteral(resourceName: "background_dark")
        tabBarController.tabBar.backgroundImage = UIImage.image(withColor: .white)
        //tabBarController.tabBar.applyPlainShadow()
        
        return tabBarController
    }

}
class TabBarController: NSObject,  UITabBarControllerDelegate {

}

class MTBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.00)
        highlightTextColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.00)
        //iconColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.00)
        //highlightIconColor = MTNavigationBarBackgroundColor
        
        backdropColor = .white
        highlightBackdropColor = .white
        renderingMode = .alwaysOriginal     //render mode
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class BasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.red
        highlightTextColor = UIColor.red
        //iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        //highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class BouncesContentView: BasicContentView {
    
    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        //self.bounceAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        //self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
}


class IrregularityBasicContentView: BouncesContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor(hex: 0x666666)
        highlightTextColor = MTColor.main
        //iconColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1.00)
        //highlightIconColor = MTNavigationBarBackgroundColor
        backdropColor = .white
        highlightBackdropColor = .white
        renderingMode = .alwaysOriginal     //render mode
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
