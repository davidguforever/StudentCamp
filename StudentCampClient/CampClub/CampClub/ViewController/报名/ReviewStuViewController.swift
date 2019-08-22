//
//  ReviewStuViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import MTCobwebs

class ReviewStuViewController: MTBaseViewController {

    var student: JSONMap = [:]
    
    @IBOutlet weak var nameField: HoshiTextField!
    @IBOutlet weak var sexField: HoshiTextField!
    @IBOutlet weak var gradeField: HoshiTextField!
    @IBOutlet weak var schoolField: HoshiTextField!
    @IBOutlet weak var mobileNoField: HoshiTextField!
    @IBOutlet weak var goodAtField: HoshiTextField!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var clubSchoolField: HoshiTextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title  = "报名"
        addNavigationBarLeftButton(self)
        
        
        
        
        if User.shared.role == .teacher, student.count > 0 , let c = student["isCheck"] as? String {
            if  c != "1" {
                confirmButton = addNavigationBarRightButton(self, action: #selector(check), text: "审核通过")
            }
            
            submitButton.isHidden = true
            
            [nameField , sexField, gradeField, schoolField, mobileNoField, goodAtField,
             emailField, clubSchoolField].forEach({$0?.isEnabled = false})
            
            nameField.text = student["stuName"] as? String
            sexField.text = student["stuSex"] as? String
            gradeField.text = student["stuGrade"] as? String
            schoolField.text = student["stuSchool"] as? String
            mobileNoField.text = student["stuTel"] as? String
            goodAtField.text = student["stuHobby"] as? String
            emailField.text = student["stuMail"] as? String
            clubSchoolField.text = student["stuClub"] as? String
            
        } else if User.shared.role == .student {
            MTHUD.showLoading()
            HttpApi.queryCampusStudent(User.shared.userName!) { (res, err) in
                MTHUD.hide()
                if let list = res?["list"] as? JSONMap {
                    self.nameField.text = list["stuName"] as? String
                    self.sexField.text = list["stuSex"] as? String
                    self.gradeField.text = list["stuGrade"] as? String
                    self.schoolField.text = list["stuSchool"] as? String
                    self.mobileNoField.text = list["stuTel"] as? String
                    self.goodAtField.text = list["stuHobby"] as? String
                    self.emailField.text = list["stuMail"] as? String
                    self.clubSchoolField.text = list["stuClub"] as? String
                } else {
                    showMessage(err)
                }
            }
        }

    }
    
    @objc func check() {
        MTHUD.showLoading()
        HttpApi.confirmCampusStudent(student["userName"] as! String) { (v, err) in
            MTHUD.hide()
            if let _ = v {
                showMessage("学生报名成功")
                delay(1, work: {
                    self.popBack()
                })
            } else {
                showMessage(err)
            }
        }
    }
    
    @IBAction func submit() {
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
        let name = nameField.text ?? ""
        let sex = sexField.text ?? ""
        let grade = gradeField.text ?? ""
        let s = schoolField.text ?? ""
        let mobile = mobileNoField.text ?? ""
        let hobby = goodAtField.text ?? ""
        let em = emailField.text ?? ""
        let club = clubSchoolField.text ?? ""
        
        let param = ["stuName": name,"stuSex": sex,"stuGrade": grade,"stuSchool": s,"stuTel":mobile ,"stuHobby": hobby,"stuMail": em,"stuClub": club] + ["userName": User.shared.userName!]
        MTHUD.showLoading()
        HttpApi.SetCampusStudent(param) { (result, error) in
            MTHUD.hide()
            if let _ = result {
                showMessage("报名成功, 请等待审核")
                
                delay(1, work: {
                    self.popVC()
                })
            } else {
                print(error!)
            }
        }
    }

}
