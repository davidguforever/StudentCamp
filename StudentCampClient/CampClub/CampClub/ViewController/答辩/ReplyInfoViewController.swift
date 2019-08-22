
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
    
    var infos: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "当前答辩顺序"
        addNavigationBarLeftButton(self)
        
        MTHUD.showLoading()
        HttpApi.getTempTurn( { (res, err) in
            MTHUD.hide()
            if let r = res, let list = r["list"]  as? String {
                self.infos = list.components(separatedBy: ",")
                self.tableView.reloadData()
            } else {
                showMessage(err)
            }
        })
        
    }
    
    
    

}
extension ReplyInfoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


extension ReplyInfoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 10.0))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = MTColor.main
        
        cell.textLabel?.text = infos[indexPath.row] + "组"
        
        return cell
    }
    
}

