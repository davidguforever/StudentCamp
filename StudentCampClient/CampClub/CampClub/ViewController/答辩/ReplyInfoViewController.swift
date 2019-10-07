
//
//  ReplyInfoViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ReplyInfoViewController: MTBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groupOrder:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "当前答辩顺序"
        addNavigationBarLeftButton(self)
        
        initGroupOrder()
        
    }
    
    func initGroupOrder(){
        MTHUD.showLoading()
        HttpApi.queryDrawlots( { (res, err) in
            MTHUD.hide()
            if let r = res, let list = r["list"]  as? JSONMap {
                let drawlist=list["drawlist"] as! String
                if(drawlist != ""){
                    self.groupOrder = drawlist.components(separatedBy: ",")
                    self.tableView.reloadData()
                }else{
                    self.groupOrder.removeAll()
                }
                print(self.groupOrder)
                
            } else {
                showMessage(err)
            }
        })
    }
    

}
extension ReplyInfoViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


extension ReplyInfoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "listCell")! as! ListableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        //cell左边的文字：自带的
        cell.textLabel?.text = String(indexPath.row+1)+":"
        //cell中间的文字
        cell.listLabel.text = "第"+groupOrder[indexPath.row]+"组"
        
        return cell
        
    }
    
}

