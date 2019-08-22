//
//  TeacherApplyingViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/15.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import MTCobwebs

class TeacherApplyingViewController: MTBaseViewController {

    @IBOutlet weak var schoolFiled: HoshiTextField!
    @IBOutlet weak var numberFiled: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "设置报名信息"
        addNavigationBarLeftButton(self)
        
    }
    
    
    @IBAction func start() {
        MTHUD.showLoading()
        HttpApi.queryCampusDeadLine { (date, err) in
            MTHUD.hide()
            if let d = date, let end = d.date, end.isGreaterThanDate(dateToCompare: Date()) {
                self.toSub()
            } else {
                showMessage(err)
            }
        }
        
    }
    
    private func toSub() {
        let total = numberFiled.text ?? ""
        let scno = schoolFiled.text ?? ""
        
        MTHUD.showLoading()
        HttpApi.SetCampusSchool(total, stuSchool: scno, teacherId: User.shared.id) { (result, error) in
            MTHUD.hide()
            if let _ = result {
                showMessage("设置成功")
                delay(1, work: {
                    self.popVC()
                })
            } else {
                showMessage(error)
            }
        }
    }
    
}
