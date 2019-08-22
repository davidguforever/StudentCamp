//
//  LoginViewController.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/4/3.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import UIKit

class LoginViewController: MTBaseViewController {

    @IBOutlet weak var smsLoginView: UIView!
    
    @IBOutlet weak var mobileNoField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        
        #if DEBUG
              mobileNoField.text = "XinQ"
            pwdField.text = "SAAA"
        mobileNoField.text = "william2000123@gmail.com"
        pwdField.text = "123456"
//        mobileNoField.text = "Mr.Qiu"
//        pwdField.text = "cherry"
        #endif
        view.addTapToCloseEditing()
        
        closeButton.setImage(AppConfig.closeImage, for: .normal)
        
        mobileNoField.becomeFirstResponder()
    }

    @IBAction func colse() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register() {
        let vc = self.storyboard?.instantiateVC(BindPwdViewController.self)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func login() {
        loginWithAccount()
    }
    

    private func loginWithAccount() {
        guard let text = mobileNoField.text, text.count > 0 else {
            return showMessage("Please enter user name")
        }

        guard let password = pwdField.text, password.count > 0 else {
            return showMessage("Please enter password")
        }
        
        view.endEditing(true)
        
        MTHUD.showLoading()
        HttpApi.login(text, pwd: password) { (res, error) in
            MTHUD.hide()
            if let r = res {
                User.shared.bind(r)
                AppDelegate.shared.loginSuccess()
            } else {
                print(error!)
            }
        }
        

    }
    

}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mobileNoField {
            pwdField.becomeFirstResponder()
        }
        if textField == pwdField {
            login()
        }

        return true
    }

}
