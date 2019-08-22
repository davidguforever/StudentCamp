//
//  SetReplyViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class SetReplyViewController: MTBaseViewController {

    @IBOutlet weak var lunField: HoshiTextField!
    @IBOutlet weak var groupsField: HoshiTextField!
    
    @IBOutlet weak var bBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置答辩信息"
        addNavigationBarLeftButton(self)
        
        
        
        nextBtn.isHidden = true
        
        MTHUD.showLoading()
        HttpApi.queryDrawlots( { (res, err) in
            MTHUD.hide()
            if let r = res, let list = r["list"]  as? JSONMap {
                self.lunField.text = list["turnnum"] as? String
                self.groupsField.text = list["singlenum"] as? String
                if let v = list["turnnum"] as? Int {
                    self.lunField.text = String(v)
                }
                if let v = list["singlenum"] as? Int {
                    self.groupsField.text = String(v)
                }
                
                self.bBtn.setTitle("更新抽签", for: .normal)
                self.addNavigationBarRightButton(self, action: #selector(self.getCurrent), text: "当前顺序")
                
                if let turnnum = list["turnnum"] as? Int ,let tmpturn = list["tmpturn"] as? Int {
                    if tmpturn < turnnum {
                        self.nextBtn.isHidden = false
                    }
                }
                
            } else {
                showMessage(err)
            }
        })
        
    }
    
    @objc func getCurrent() {
        let vc = UIStoryboard.Scene.replyInfo
        vc.hidesBottomBarWhenPushed = true
        pushVC(vc)
    }
    

    @IBAction func begin() {
        if let lun = Int(lunField.text ?? ""), let gro = Int(groupsField.text ?? ""), lun > 0, gro > 0 {
            let all = lun * gro
            let items = (1...all).shuffled()
            
            let list = items.map({String($0)}).joined(separator:",")
            
            MTHUD.showLoading()
            HttpApi.setDrawlots(String(lun), singlenum: String(gro), drawlist: list) { (res, err) in
                MTHUD.hide()
                if let _ = res {
                    showMessage("设置成功")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    showMessage(err)
                }
            }
            
        }
    }
    
    @IBAction func next() {
            
        MTHUD.showLoading()
        HttpApi.nextTurn({ (res, err) in
            MTHUD.hide()
            if let _ = res {
                showMessage("设置成功")
            } else {
                showMessage(err)
            }

        })
    }

}
