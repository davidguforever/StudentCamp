//
//  MTHud.swift
//  MovelRater
//
//  Created by Luochun on 2019/4/20.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation

import UIKit

struct MTHUD {
    
    
    static func showLoading() {
        KRProgressHUD.set(viewOffset: -40)
        KRProgressHUD.set(style: .black)
        KRProgressHUD.shared.show(withMessage: "Loading...", isLoading: true, completion: nil)
    }
    
    static func hide(_ completion: (() -> Void)? = nil)  {
        KRProgressHUD.dismiss {
            completion?()
        }
    }
    
    
}


