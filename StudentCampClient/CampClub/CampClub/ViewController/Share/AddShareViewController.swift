//
//  AddShareViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/24.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class AddShareViewController: MTBaseViewController {

    @IBOutlet weak var titleField: HoshiTextField!
    
    @IBOutlet weak var desTextView: MTPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "心得"
        addNavigationBarLeftButton(self)
        
        addNavigationBarRightButton(self, action: #selector(submit), text: "发布")
    }

    @objc func submit() {
        if let title = titleField.text, let des = desTextView.text {
            MTHUD.showLoading()
            HttpApi.contentAdd(User.shared.userName!, title: title, content: des) { (res, err) in
                MTHUD.hide()
                if let _ = res {
                    showMessage("发布成功")
                    self.popVC()
                } else {
                    showMessage(err)
                }
            }
        }
    }
}
