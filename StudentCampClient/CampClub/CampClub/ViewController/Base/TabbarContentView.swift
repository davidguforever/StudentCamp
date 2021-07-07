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

        
        let v1 = UIStoryboard.Scene.home
        let v2 = UIStoryboard.Scene.share
        let v3 = UIStoryboard.Scene.mine
        
        let n1 = MTNavigationController(rootViewController: v1)
        let n2 = MTNavigationController(rootViewController: v2)
        let n3 = MTNavigationController(rootViewController: v3)
        
        n1.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "营务", image: #imageLiteral(resourceName: "home"), selectedImage: #imageLiteral(resourceName: "home_s"))
        n2.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "分享", image: #imageLiteral(resourceName: "cate"), selectedImage: #imageLiteral(resourceName: "cate_s"))
        n3.tabBarItem = ESTabBarItem.init(IrregularityBasicContentView(), title: "个人", image: #imageLiteral(resourceName: "mine"), selectedImage: #imageLiteral(resourceName: "mine_s"))
        
        tabBarController.viewControllers = [n1, n2, n3]

        tabBarController.tabBar.shadowImage = #imageLiteral(resourceName: "Transparent")
        tabBarController.tabBar.backgroundImage = UIImage.image(withColor: .white)

        
        return tabBarController
    }

}
class TabBarController: NSObject,  UITabBarControllerDelegate {

}

class MTBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = MTTheme.getFontColor()
        highlightTextColor = MTTheme.getFontColor()

        
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


class IrregularityBasicContentView: BouncesContentView,ThemeProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addThemeObserver()
        textColor = UIColor(hex: 0x666666)
        highlightTextColor = MTTheme.getFontColor()
        backdropColor = .white
        highlightBackdropColor = .white
        renderingMode = .alwaysOriginal     //render mode
    }
    override func updateTheme() {
        super.updateTheme()
        highlightTextColor = MTTheme.getFontColor()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
