//
//  MyGroupInfoViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class MyGroupInfoViewController: MTBaseViewController {

    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var groupNoField: HoshiTextField!
    @IBOutlet weak var teacherField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的分组"
        addNavigationBarLeftButton(self)
        
        HttpApi.queryGroupStudent(User.shared.userName!) { (res, error) in
            if let r = res, let v = r["list"] as? JSONMap {
                
                self.nameField.text = v["groupNum"] as? String
                self.groupNoField.text = v["groupStuNum"] as? String
                self.teacherField.text = v["stuSchool"] as? String
                
            } else {
                showMessage(error)
            }
        }
    }
    

}
