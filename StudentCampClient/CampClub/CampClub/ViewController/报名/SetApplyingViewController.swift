//
//  SetApplyingViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import MTCobwebs

class SetApplyingViewController: MTBaseViewController {

    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var currentHeightLayout: NSLayoutConstraint!
    
    @IBOutlet weak var numberFiled: HoshiTextField!
    @IBOutlet weak var schoolNumberFiled: HoshiTextField!
    @IBOutlet weak var endTimeFiled: HoshiTextField!
    
    @IBOutlet weak var startApplyButton: UIButton!
    
    var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置报名信息"
        addNavigationBarLeftButton(self)
        
        currentHeightLayout.constant = 0
        //finishButton = addNavigationBarRightButton(self, action: #selector(finish), text: "完成")
        
        HttpApi.queryCampusManager { (res, error) in
            if let r = res, let v = r["list"] as? JSONMap {
                self.currentHeightLayout.constant = 50
                if let n = v["tmpNum"] as? String {
                    self.currentNumberLabel.text =  "当前营员实际人数: " + n
                }
                
                self.numberFiled.text = v["totalNum"] as? String
                self.schoolNumberFiled.text = v["schoolNum"] as? String
                self.endTimeFiled.text = v["deadLine"] as? String
            } else {
            }
        }
    }
    

    @objc func finish() {
        
    }
    
    @IBAction func start() {
        let total = numberFiled.text ?? ""
        let scno = schoolNumberFiled.text ?? ""
        guard let t = endTimeFiled.text, t.count > 0 , let  _ = t.date else {return showMessage("日期格式 yyyy-MM-dd")}
        HttpApi.SetCampusManager(total, schoolNum: scno, dataTime: t) { (result, error) in
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
