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
        
            let mode=3
            switch mode {
            case 1:
                //管理员账号
                mobileNoField.text = "doris@apple.com"
            case 2:
                //营员账号
                mobileNoField.text = "william2000123@gmail.com"
            default:
                //教师账号
                mobileNoField.text = "13578700066"
            }
            //密码统一为123456
            pwdField.text = "123456"
        
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
                if let errm=error{
                    print(errm)
                    var errorTxt:String
                    if((error?.contains("未能连接到服务器"))!){
                        errorTxt = "网络错误，请重试"
                    }
                    else{
                        errorTxt = error!
                    }
                    showMessage(errorTxt)
                }else{
                    showMessage("未能连接到服务器,可能是网络错误或服务器维护")
                }

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
