//
//  ChangePwdViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/7/21.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ChangePwdViewController: MTBaseViewController {

    
    @IBOutlet weak var pwdField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        title = "修改密码"
        
    }
    
    
    @IBAction func save() {
        guard let text = pwdField.text, text.count > 0 else {return}
        view.endEditing(true)
        MTHUD.showLoading()
        HttpApi.changePwd( User.shared.userName! , pwd: text) { (res, err) in
            MTHUD.hide()
            if let _ = res {
                showMessage( "修改成功")
                self.popBack()
            } else {
                showMessage(err)
            }
        }
    }

}
