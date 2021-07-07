//
//  BindPwdViewController.swift
//  HouseShop
//
//  Created by Luochun on 2018/7/25.
//  Copyright © 2018 Mantis Group. All rights reserved.
//

import UIKit



/// 设置密码
class BindPwdViewController: MTBaseViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!
    
    @IBOutlet weak var confirmPwdField: UITextField!
    
    @IBOutlet weak var tokenField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
        @IBOutlet weak var ibSegment: PinterestSegment!
        @IBOutlet weak var tokenHeightLayout: NSLayoutConstraint!
    
    override func setColors() {
        loginButton.backgroundColor = MTTheme.getButtonColor()
        ibSegment.indicatorColor=MTTheme.getButtonColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册"
        
        
        addNavigationBarLeftButton(self)
        self.view.backgroundColor  = .white
        //pwdField.addPaddingLeft(15)
        
        pwdField.delegate = self
        confirmPwdField.delegate = self
        
        
        
        pwdField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        confirmPwdField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
        
        tokenHeightLayout.constant = 0
        ibSegment.titles  = ["学生", "指导教师", "管理"]
        ibSegment.valueChange = { index in
            if index > 0 {
                self.tokenHeightLayout.constant = 50
                self.tokenField.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
                self.tokenHeightLayout.constant = 0
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        userNameField.becomeFirstResponder()
    }
    
    /// 检测状态
    @objc private func editingChanged() {
        if let name = userNameField.text, name.count > 0, let text = pwdField.text, text.count > 0 , let confirm = confirmPwdField.text, confirm.count > 0 {
            if confirm == text {
                loginButton.isEnabled = true
                return
            }
        }
        
        loginButton.isEnabled = false
        
    }

    
    @IBAction func login() {
        guard let name = userNameField.text, name.count > 0 else {
            return showMessage("Please enter user name")
        }
        guard let text = pwdField.text, text.count > 0 else {
            return showMessage("Please enter user password")
        }
        guard let confirm = confirmPwdField.text, confirm.count > 0 else {
            return showMessage("Please enter confirm password")
        }
        guard text == confirm else {
            return showMessage("two passsword are differet")
        }
        
        if ibSegment.selectIndex == 1 {
            guard let to = tokenField.text, to == "2019xianmentutor" else {
                return showMessage("密钥错误")
            }
        }
        if ibSegment.selectIndex == 2 {
            guard let to = tokenField.text, to == "2019xianmenapple" else {
                return showMessage("密钥错误")
            }
        }
        
        view.endEditing(true)
        
        
        
        MTHUD.showLoading()
        HttpApi.register(name, pwd: text, type:  ibSegment.selectIndex + 1) { (res, error) in
            MTHUD.hide()
            if let r = res {
                    User.shared.bind(r)
                    AppDelegate.shared.loginSuccess()
            } else {
                print(error ?? "")
            }
        }
        
        

    }
}

extension BindPwdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pwdField {
            confirmPwdField.becomeFirstResponder()
        }
        return true
    }
}
