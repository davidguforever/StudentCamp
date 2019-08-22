//
//  ChangeViewController.swift
//  MovelRater
//
//  Created by Luochun on 2019/4/22.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ChangeViewController: MTBaseViewController {

    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        title = "权限转移"
        
    }

    
    @IBAction func save() {
        guard let name = nameField.text, name.count > 0 else {return}
        view.endEditing(true)
        MTHUD.showLoading()
        HttpApi.enchangeType(User.shared.userName!, user2Name: name) { (res, err) in
            MTHUD.hide()
            if let _ = res {
                showMessage( "转移成功")
                self.popBack()
            } else {
                showMessage(err)
            }
        }
    }
}
