//
//  AppDelegate+Ext.swift
//  Gfintech
//
//  Created by Luochun on 2017/3/18.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension AppDelegate: UITabBarControllerDelegate {
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let navigation = viewController as! MTNavigationController
//        let vc = navigation.viewControllers[0]
//        if vc.isKind(of: ProfileViewController.self) || vc.isKind(of: CollectionViewController.self) || vc.isKind(of: ) {
//            if !User.isLogined {
//                AppDelegate.toLogin()
//                return false
//            }
//        }
//        return true
//    }
}


extension AppDelegate {
    
    static var shared: AppDelegate {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate
            }
            return AppDelegate()
        }
    }
    
    enum PathName: String {
        case launch = "launch"
        case guides = "guides"
    }
    
    static func toLogin() {
        let vc = UIStoryboard.Scene.login
        
        AppDelegate.root.present(MTNavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    static var root: UIViewController  {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.window!.rootViewController!
        }
    }
    
    
    /// 显示引导页
    func showIntro() {
        
    }
    

    
    //跳转到应用的AppStore页页面
    static func gotoWeb(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


////MARK: - CrashEye
//extension AppDelegate: CrashEyeDelegate {
//    
//    /// god's crash eye callback
//    func crashEyeDidCatchCrash(with model:CrashModel) {
//        print(model)
//    }
//}

public extension UIApplication {
    static var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    static var supportDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
    }
    
    static var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
