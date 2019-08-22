//
//  AppDelegate.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/3/12.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import UIKit
import CoreGraphics
import WebKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window!.frame  = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width + 0.01, height: UIScreen.main.bounds.height + 0.01)
        window!.backgroundColor = UIColor.white
        
        UITextField.appearance().tintColor = MTColor.main
        UITextView.appearance().tintColor = MTColor.main
        
        IQKeyboardManager.shared.enable = true
        
        if User.isLogined {
            loginSuccess()
        } else {
            signout()
        }
        
        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func loginSuccess() {
        self.window?.rootViewController = ESTabBarController.createTabbar()
    }
    func signout() {
        User.logout()
        
        let vc = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateVC(LoginViewController.self)!
        self.window?.rootViewController = MTNavigationController(rootViewController: vc)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


