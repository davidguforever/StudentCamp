//
//  TipsAlertViewController.swift
//  MarriageClass
//
//  Created by Luo chun on 2018/12/20.
//  Copyright © 2018 Luo chun. All rights reserved.
//

import UIKit
import MTCobwebs
import MTUIFlash
import SwiftEntryKit

extension UIViewController {
    
    /// 提示弹出框
    ///
    /// - Parameters:
    ///   - completion: 完成输入
    ///   - cancelHandle: 取消输入
    func displayTipsAlert(_ title: String, content: String, completion: @escaping () -> (), cancelHandle: (() -> ())? = nil  ) {
        /// 输入密码
        let vc = UIStoryboard.main.instantiateVC(TipsAlertViewController.self)!
        vc.completionHandle = completion
        vc.cancelHandle = cancelHandle
        vc.tipsTitle  = title
        vc.content = content
        //vc.tipsLabel.fi
        SwiftEntryKit.display(entry: vc, using: Presets.centerAlertAttributes, presentInsideKeyWindow: true)
    }
}

class TipsAlertViewController: MTBaseViewController {

    var tipsTitle: String?
    var content: String?
    
    var completionHandle: (() -> ())?
    var cancelHandle: (() -> ())?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tipsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.titleLabel.text  = tipsTitle
        self.tipsLabel.text  = content
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    @IBAction func cancel() {
        cancelHandle?()
        SwiftEntryKit.dismiss()
    }
    
    
    @IBAction func submit() {
        completionHandle?()
        
        SwiftEntryKit.dismiss()
    }

}
