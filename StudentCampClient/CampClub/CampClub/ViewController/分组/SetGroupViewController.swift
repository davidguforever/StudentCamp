//
//  SetGroupViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import MTCobwebs

let items = ["忽略", "严格"]

class SetGroupViewController: MTBaseViewController {

    @IBOutlet weak var groupNoField: HoshiTextField!
    @IBOutlet weak var maxNoField: HoshiTextField!
    @IBOutlet weak var schoolTypeField: HoshiTextField!
    @IBOutlet weak var sexField: HoshiTextField!
    @IBOutlet weak var ageField: HoshiTextField!
    @IBOutlet weak var goodAtField: HoshiTextField!
    
    @IBOutlet weak var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置分组信息"
        addNavigationBarLeftButton(self)
        addNavigationBarRightButton(self, action: #selector(divide), text: "开始分组")
        
        HttpApi.queryGroupMsg { (res, error) in
            if let r = res, let v = r["list"] as? JSONMap {
                
                self.groupNoField.text = v["groupNum"] as? String
                self.maxNoField.text = v["groupStuNum"] as? String
                if let v = v["stuSchool"] as? String {
                    self.schoolTypeField.text = v == "1" ? "严格": "忽略"
                }
                if let v = v["stuSex"] as? String {
                    self.sexField.text = v == "1" ? "严格": "忽略"
                }
                if let v = v["stuGrade"] as? String {
                    self.ageField.text = v == "1" ? "严格": "忽略"
                }
                if let v = v["stuHobby"] as? String {
                    self.goodAtField.text = v == "1" ? "严格": "忽略"
                }
                
            } else {
                [self.schoolTypeField, self.sexField, self.ageField, self.goodAtField].forEach({$0?.text = items[0]})
            }
        }
    }
    
    @objc func divide() {
        MTHUD.showLoading()
        HttpApi.queryCampusManager { (res, error) in
            MTHUD.hide()
            if let r = res, let _ = r["list"] as? JSONMap {
                showMessage("已经开始")
                delay(1, work: {
                    self.popVC()
                })
            } else {
                showMessage(error)
            }
        }
        
    }
    
    @IBAction func beginGroup() {
        guard let t = groupNoField.text, t.count > 0  else {return showMessage("")}
        guard let max = maxNoField.text, max.count > 0 else {return showMessage("")}
        guard let scname = schoolTypeField.text, scname.count > 0 else {return showMessage("")}
        guard let sex = sexField.text, sex.count > 0 else {return showMessage("")}
        guard let age = ageField.text, age.count > 0 else {return showMessage("")}
        guard let goodat = goodAtField.text, goodat.count > 0 else {return showMessage("")}
        
        MTHUD.showLoading()
        HttpApi.setGroupMsg(t, groupStuNum: max, stuSex: items.indexes(of: sex)[0], stuGrade: items.indexes(of: age)[0],
                            stuSchool: items.indexes(of: scname)[0], stuHobby: items.indexes(of: goodat)[0], handle: { (res, error) in
            MTHUD.hide()
            if let _ = res {
                showMessage("设置成功")
                delay(1, work: {
                    self.popVC()
                })
            } else {
                showMessage(error)
            }
        })
    }

}


extension SetGroupViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if [schoolTypeField, sexField, ageField, goodAtField].contains(textField) {
            showPopupMenu("请选择", rows: items, selectedIndex: items.indexes(of: textField.text!)[0]) { (index) in
                textField.text = items[index]
            }
            return false
        }
        return true
    }
}
