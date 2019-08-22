//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import UIKit

//let STPopupFirstResponderDidChange = Notification.Name(rawValue: "STPopupFirstResponderDidChange")
//
//extension UIResponder: SelfAware {
//    static let _onceToken = UUID().uuidString
//    public static func awake() {
//       DispatchQueue.once(token: _onceToken) {
//            swizzle(selector: #selector(becomeFirstResponder), to: #selector(st_becomeFirstResponder))
//        
//       }
//    }
//    
//    class func swizzle(selector: Selector, to swizzledSelector: Selector) {
//        let originalMethod = class_getInstanceMethod(self, selector)
//        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
//        method_exchangeImplementations(originalMethod!, swizzledMethod!)
//    }
//
//    
//    @objc func st_becomeFirstResponder() -> Bool {
//        let accepted = st_becomeFirstResponder()
//        if accepted {
//            NotificationCenter.default.post(name: STPopupFirstResponderDidChange, object: self)
//        }
//        return accepted
//    }
//}


