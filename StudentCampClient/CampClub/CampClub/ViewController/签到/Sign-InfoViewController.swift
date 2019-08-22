//
//  Sign-InfoViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class Sign_InfoViewController: MTBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var infos: JSONMap = [:]
    
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "签到学生"
        addNavigationBarLeftButton(self)
        
        getInfos()
    }
    
    func getInfos() {
        guard let d = date else {
            return
        }
        if User.shared.role == .manager {
            MTHUD.showLoading()
            HttpApi.querySignInManager(d) { (result, err) in
                MTHUD.hide()
                if let list = result?["list"] as? JSONMap {
                    self.infos = list
                    self.tableView.reloadData()
                } else {
                    showMessage(err)
                }
            }
        } else {
            MTHUD.showLoading()
            HttpApi.querySignInTeacher(d, teacher: User.shared.id) { (result, err) in
                MTHUD.hide()
                if let list = result?["list"] as? JSONMap {
                    self.infos = list
                    self.tableView.reloadData()
                } else {
                    showMessage(err)
                }
            }
        }
    }

}

extension Sign_InfoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


extension Sign_InfoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if User.shared.role == .teacher {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 40))
            view.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.96, alpha:1.00)
            let tipsLabel = UILabel(frame: CGRect(x: 20, y: 00, width: tableView.width, height: 40))
            let key = Array(infos.keys)[section]
            tipsLabel.text  = key
            tipsLabel.textColor = MTColor.des666
            //tipsLabel.textAlignment = .center
            tipsLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            view.addSubview(tipsLabel)
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 10))
            view.backgroundColor = .clear
            return view
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if User.shared.role == .teacher {
            return 40
        }
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if User.shared.role == .teacher {
            return infos.keys.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if User.shared.role == .teacher {
            return (infos[Array(infos.keys)[section]] as! [String]).count
        }
        return infos.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = MTColor.main
        
        
        if User.shared.role == .teacher {
            let key = Array(infos.keys)[indexPath.section]
            //cell.textLabel?.text = key
            
            cell.textLabel?.numberOfLines = 1
            cell.detailTextLabel?.text = ""
            if let stus = infos[key] as? [String] {
                cell.textLabel?.text = stus[indexPath.row]
            }
        } else {
            let key = Array(infos.keys)[indexPath.row]
            cell.textLabel?.text = key
        
            if let school = infos[key] as? JSONMap {
                cell.detailTextLabel?.numberOfLines = 2
                cell.detailTextLabel?.text = Array(school.keys)[0] + "\n" + (Array(school.values)[0] as! String)
            }
        }
        
        let line = UIView(frame: CGRect(x: 15, y: 59.5, width: view.width, height: 0.5))
        line.backgroundColor = UIColor(hex: 0xeeeeee)
        cell.contentView.addSubview(line)
        
        return cell
    }
    
}
